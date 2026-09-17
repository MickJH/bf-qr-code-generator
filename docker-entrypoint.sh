#!/bin/sh
set -e

# Default missing vars to empty so envsubst always produces a valid file.
: "${BF_CARD_NUMBER:=}"
: "${BF_DEVICE_ID:=}"
: "${BF_CONSTANT:=}"

# Render only our known placeholders; leaves any other $... in the file untouched.
envsubst '${BF_CARD_NUMBER} ${BF_DEVICE_ID} ${BF_CONSTANT}' \
  < /usr/share/nginx/html/env-config.template.js \
  > /usr/share/nginx/html/env-config.js

exec "$@"
