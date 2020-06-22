#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

ln -s "${SCRIPT_DIR}"/.bashrc ~
ln -s "${SCRIPT_DIR}"/.vimrc ~
ln -s "${SCRIPT_DIR}"/.tmux.conf ~
