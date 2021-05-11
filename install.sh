#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

which git || (sudo yum update -y && sudo yum install -y git)

if [[ ! -d 'dotfiles' ]]; then
  git clone https://github.com/os1ma/dotfiles.git
fi

./dotfiles/link.sh
