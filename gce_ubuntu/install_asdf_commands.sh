#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly ASDF_VERSION='v0.7.8'

install_asdf_if_not_exist(){
  sudo apt install -y curl git
  if [[ ! -d ~/.asdf ]]; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch "${ASDF_VERSION}"
  fi
  source ~/.bashrc
}

install_plugin_dependencies() {
  # Node.js
  sudo apt install -y dirmngr gpg curl
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'

  # Python
  sudo apt install -y --no-install-recommends \
    make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev

  # Ruby
  sudo apt install -y \
    autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev \
    libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

  # Java
  sudo apt install -y jq curl

  # Gradle
  sudo apt install -y unzip
}

get_plugins_by_tool_versions() {
  cat .tool-versions \
    | cut -d ' ' -f 1
}

exist_asdf_plugin() {
  local plugin="$1"
  [[ "$(asdf plugin-list | grep "${plugin}" | wc -l)" -ne 0 ]]
}

add_asdf_plugin_if_not_exist() {
  local plugin="$1"

  if ! exist_asdf_plugin "${plugin}"; then
    asdf plugin-add "${plugin}"
  fi
}

main() {
  sudo apt update

  install_asdf_if_not_exist

  install_plugin_dependencies

  local plugins="$(get_plugins_by_tool_versions)"

  for plugin in "${plugins[@]}"; do
    add_asdf_plugin_if_not_exist "${plugin}"
  done

  # install
  asdf install
}

main "$@"
