#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

if [[ "$(uname)" == 'Darwin' ]]; then
  pbcopy
else
  xsel -bi
fi
