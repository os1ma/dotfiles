#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly ASDF_VERSION='v0.7.8'

main(){
  if [[ ! -d ~/.asdf ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_VERSION}"
  fi
  source ~/.bashrc
}

main "$@"
