#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly ASDF_VERSION='v0.7.8'
readonly NODE_VERSION='12.18.1'

exist_asdf_plugin() {
  local plugin="$1"
  [[ "$(asdf plugin-list | grep "${plugin}" | wc -l)" -ne 0 ]]
}

# asdf
if [[ ! -d ~/.asdf ]]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_VERSION}"
fi

# node
if ! exist_asdf_plugin nodejs; then
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
fi
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
asdf install nodejs "${NODE_VERSION}"
asdf global nodejs "${NODE_VERSION}"
npm install -g yarn
