#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
#set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

cd "${SCRIPT_DIR}/downloads"

download_if_not_exist() {
  local target="$1"
  local url="$2"
  if [[ ! -f "$1" ]]; then
    curl -o "$1" "$2"
  fi
}

download_if_not_exist git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
download_if_not_exist git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
