#!/bin/sh

BUCKET="${WERCKER_PUBLISH_TO_S3_BUCKET}"
SRC="${WERCKER_PUBLISH_TO_S3_SRC}"
ROLE="${WERCKER_PUBLISH_TO_S3_ROLE}"

echo "Publishing to bucket ${BUCKET} ..."
exec node "${WERCKER_STEP_ROOT}/cli.js" -b "${BUCKET}" -s "${SRC}" -r "${ROLE}"
