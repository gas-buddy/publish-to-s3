output "write_role_arn" {
  value = "${aws_iam_role.wercker.arn}"
}

output "bucket_name" {
  value = "${aws_s3_bucket.assets.id}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.assets.bucket_domain_name}"
}
