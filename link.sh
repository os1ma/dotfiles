#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly CODE_SERVER_SETTING_DIR="${HOME}/.local/share/code-server/User/"

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

ln -sf "${SCRIPT_DIR}"/.bashrc ~
ln -sf "${SCRIPT_DIR}"/.vimrc ~
ln -sf "${SCRIPT_DIR}"/.tmux.conf ~

ln -sf "${SCRIPT_DIR}"/.Xmodmap ~

ln -sf "${SCRIPT_DIR}"/.tool-versions ~
ln -sf "${SCRIPT_DIR}"/.asdfrc ~

mkdir -p ~/.aws
ln -sf "${SCRIPT_DIR}"/aws_config ~/.aws/config

mkdir -p "${CODE_SERVER_SETTING_DIR}"
ln -sf "${SCRIPT_DIR}"/settings.json "${CODE_SERVER_SETTING_DIR}"
