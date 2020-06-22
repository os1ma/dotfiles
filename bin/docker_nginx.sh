#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly IMAGE='nginx:1.17.6-alpine'

docker run \
  --rm \
  -p 8080:80 \
  -v "$(pwd):/usr/share/nginx/html" \
  "${IMAGE}"
