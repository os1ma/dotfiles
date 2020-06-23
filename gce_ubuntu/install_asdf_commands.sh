#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly ASDF_VERSION='v0.7.8'

readonly NODE_VERSION='12.18.1'
readonly YARN_VERSION='1.22.4'

readonly PYTHON_VERSION='3.8.3'

readonly RUBY_VERSION='2.7.1'

readonly JAVA_VERSION='amazon-corretto-8.252.09.1'
readonly MAVEN_VERSION='3.6.3'
readonly GRADLE_VERSION='6.5'

readonly TERRAFORM_VERSION='0.12.26'
readonly PACKER_VERSION='1.6.0'

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
sudo apt install -y curl git
if [[ ! -d ~/.asdf ]]; then
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_VERSION}"
fi
source ~/.bashrc

# Node.js
sudo apt install -y dirmngr gpg curl
if ! exist_asdf_plugin nodejs; then
  asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs.git
fi
bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
asdf install nodejs "${NODE_VERSION}"
asdf global nodejs "${NODE_VERSION}"
install_asdf_plugin_globally yarn "${YARN_VERSION}"

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

# Java
sudo apt install -y jq curl
install_asdf_plugin_globally java "${JAVA_VERSION}"
install_asdf_plugin_globally maven "${MAVEN_VERSION}"
sudo apt install -y unzip
install_asdf_plugin_globally gradle "${GRADLE_VERSION}"

# HashiCorp
install_asdf_plugin_globally terraform "${TERRAFORM_VERSION}"
install_asdf_plugin_globally packer "${PACKER_VERSION}"

# Kubernetes
install_asdf_plugin_globally kubectl "${KUBECTL_VERSION}"
install_asdf_plugin_globally kubectx "${KUBECTX_VERSION}"
