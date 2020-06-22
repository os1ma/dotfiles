#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

cd "${HOME}"

if [[ ! -d 'dotfiles' ]]; then
  git clone https://github.com/os1ma/dotfiles.git
fi

./dotfiles/link.sh
