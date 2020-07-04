#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

exist_user() {
  local user="$1"

  cat /etc/passwd \
    | cut -d':' -f1 \
    | grep -q -E "^${user}$"
}

main() {
  local user="$1"

  while true
  do
    if exist_user "${user}"; then
      break;
    else
      echo 'Waiting for user creating'
      sleep 1
    fi
  done
}

main "$@"
