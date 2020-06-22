#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly ASDF_VERSION='v0.7.8'
readonly NODE_VERSION='12.18.1'
readonly PYTHON_VERSION='3.8.3'
readonly RUBY_VERSION='2.7.1'
readonly KUBECTL_VERSION='1.18.4'
readonly KUBECTX_VERSION='0.9.0'

exist_asdf_plugin() {
  local plugin="$1"
  [[ "$(asdf plugin-list | grep "${plugin}" | wc -l)" -ne 0 ]]
}

install_asdf_plugin_globally() {
  local plugin="$1"
  local version="$2"

  if ! exist_asdf_plugin "${plugin}"; then
    asdf plugin-add "${plugin}"
  fi
  asdf install "${plugin}" "${version}"
  asdf global "${plugin}" "${version}"
}

sudo apt update

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
sudo apt install -y --no-install-recommends \
  make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
  wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
install_asdf_plugin_globally python "${PYTHON_VERSION}"

# Ruby
sudo apt install -y \
  autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
  libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev
install_asdf_plugin_globally ruby "${RUBY_VERSION}"

# Kubernetes
install_asdf_plugin_globally kubectl "${KUBECTL_VERSION}"
install_asdf_plugin_globally kubectx "${KUBECTX_VERSION}"
