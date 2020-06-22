#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

cd "${SCRIPT_DIR}"

./install_asdf_commands.sh
./install_cli_tools.sh
./install_gui_tools.sh
./setup_vnc.sh
