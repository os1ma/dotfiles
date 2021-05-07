#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

main() {
  "${SCRIPT_DIR}"/install_asdf.sh
  "${SCRIPT_DIR}"/install_docker.sh
  "${SCRIPT_DIR}"/install_code_server.sh
}

main "$@"
