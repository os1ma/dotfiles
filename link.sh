#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

ln -sf "${SCRIPT_DIR}"/.bashrc ~
ln -sf "${SCRIPT_DIR}"/.vimrc ~
ln -sf "${SCRIPT_DIR}"/.tmux.conf ~
