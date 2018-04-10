#!/bin/sh

BUCKET="${WERCKER_NODE_S3_DEPLOY_BUCKET}"
SRC="${WERCKER_NODE_S3_DEPLOY_SRC}"
ROLE="${WERCKER_NODE_S3_DEPLOY_ROLE}"

npm install --production
node ./cli.js -b "${BUCKET}" -s "${SRC}" -r "${ROLE}"
