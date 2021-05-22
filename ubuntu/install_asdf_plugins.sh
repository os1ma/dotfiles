#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly ASDF_VERSION='v0.7.8'

pre_add_plugins() {
  sudo apt update

  # Node.js
  sudo apt install -y dirmngr gpg curl

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

post_add_plugins() {
  # Node.js
  bash -c '${ASDF_DATA_DIR:=$HOME/.asdf}/plugins/nodejs/bin/import-release-team-keyring'
}

get_plugins_by_tool_versions() {
  cat ~/.tool-versions \
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
  pre_add_plugins

  local plugins="$(get_plugins_by_tool_versions)"

  for plugin in ${plugins[@]}; do
    add_asdf_plugin_if_not_exist "${plugin}"
  done

  post_add_plugins

  asdf install
}

main "$@"
