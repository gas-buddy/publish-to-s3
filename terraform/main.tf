locals {
  bucket_prefix = "${var.project_name}-static-assets-"
  role_prefix = "${var.project_name}-wercker-"
  policy_prefix = "${var.project_name}-write-to-bucket-"
}

module "tags" {
  source = "github.com/jasisk/terraform-aws-default-tags?ref=0.0.1"
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "assets" {
  bucket_prefix = "${local.bucket_prefix}"
  acl = "private"
  tags = "${module.tags.map}"
  versioning {
    enabled = true // because there is no overwrite control
  }
  lifecycle {
    ignore_changes = ["tags.LastModifiedBy", "tags.LastModifiedTime"]
  }
}

resource "aws_s3_bucket_policy" "assets" {
  bucket = "${aws_s3_bucket.assets.id}"
  policy = "${data.aws_iam_policy_document.assets_bucket_policy.json}"
}

resource "aws_iam_user" "wercker" {
  name = "wercker-deploy"
  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_user_policy" "wercker" {
  policy = "${data.aws_iam_policy_document.assume_role.json}"
  user = "${aws_iam_user.wercker.name}"
} 

resource "aws_iam_role" "wercker" {
  name_prefix = "${local.role_prefix}"
  assume_role_policy = "${data.aws_iam_policy_document.root_trust.json}"
}

resource "aws_iam_policy" "wercker" {
  name_prefix = "${local.policy_prefix}"
  policy = "${data.aws_iam_policy_document.assets_put.json}"
}

resource "aws_iam_role_policy_attachment" "wercker" {
  role = "${aws_iam_role.wercker.name}"
  policy_arn = "${aws_iam_policy.wercker.arn}"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    resources = ["${aws_iam_role.wercker.arn}"]
  }
}

data "aws_iam_policy_document" "root_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
}

data "aws_iam_policy_document" "assets_put" {
  // listBucket isn't necessary if you use the --force flag in the upload step
  statement {
    actions = ["s3:listBucket"]
    resources = ["${aws_s3_bucket.assets.arn}"]
  }
  statement {
    actions = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.assets.arn}/*"]
  }
}

data "aws_iam_policy_document" "assets_bucket_policy" {
  statement {
    actions = ["s3:getObject"]
    principals {
      type = "AWS"
      identifiers = ["*"]
    }
    resources = ["${aws_s3_bucket.assets.arn}/*"]
  }
}
