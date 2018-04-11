#!/bin/sh

BUCKET="${WERCKER_PUBLISH_TO_S3_BUCKET}"
SRC="${WERCKER_PUBLISH_TO_S3_SRC}"
ROLE="${WERCKER_PUBLISH_TO_S3_ROLE}"
LOGLEVEL="${WERCKER_PUBLISH_TO_S3_LOGLEVEL:-"info"}"

echo "Publishing to bucket ${BUCKET} ..."
node "${WERCKER_STEP_ROOT}/cli.js" -l "${LOGLEVEL}" -b "${BUCKET}" -s "${SRC}" -r "${ROLE}" || exit 1
