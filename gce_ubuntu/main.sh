#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

main() {
  time "${SCRIPT_DIR}"/install_asdf_commands.sh
  time "${SCRIPT_DIR}"/install_cli_tools.sh
}

time main "$@"
