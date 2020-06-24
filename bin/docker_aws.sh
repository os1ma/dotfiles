#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly IMAGE='amazon/aws-cli:2.0.25'

docker run \
  --rm \
  -it \
  -v ~/.aws:/root/.aws \
  "${IMAGE}" \
  "$@"
