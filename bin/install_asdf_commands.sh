#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly ASDF_VERSION='v0.7.8'
readonly NODE_VERSION='12.18.1'
readonly PYTHON_VERSION='3.8.3'
readonly RUBY_VERSION='2.7.1'

exist_asdf_plugin() {
  local plugin="$1"
  [[ "$(asdf plugin-list | grep "${plugin}" | wc -l)" -ne 0 ]]
}

# asdf
if [[ ! -d ~/.asdf ]]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_VERSION}"
fi

# Node.js
if ! exist_asdf_plugin nodejs; then
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
fi
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
asdf install nodejs "${NODE_VERSION}"
asdf global nodejs "${NODE_VERSION}"
npm install -g yarn

# Python
if ! exist_asdf_plugin python; then
  asdf plugin-add python
fi
sudo apt update
sudo apt install -y --no-install-recommends \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
asdf install python "${PYTHON_VERSION}"
asdf global python "${PYTHON_VERSION}"

# Ruby
if ! exist_asdf_plugin ruby; then
  asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git
fi
sudo apt install -y \
  autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
  libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
asdf install ruby "${RUBY_VERSION}"
asdf global ruby "${RUBY_VERSION}"
