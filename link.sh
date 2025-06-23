#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"

ln -sf "${SCRIPT_DIR}"/.bash_profile ~
ln -sf "${SCRIPT_DIR}"/.bashrc ~
ln -sf "${SCRIPT_DIR}"/.zshrc ~
ln -sf "${SCRIPT_DIR}"/.vimrc ~
ln -sf "${SCRIPT_DIR}"/.tmux.conf ~

ln -sf "${SCRIPT_DIR}"/.Xmodmap ~
ln -sf "${SCRIPT_DIR}"/.inputrc ~

ln -sf "${SCRIPT_DIR}"/.tool-versions ~
ln -sf "${SCRIPT_DIR}"/.asdfrc ~

mkdir -p ~/.aws
ln -sf "${SCRIPT_DIR}"/aws_config ~/.aws/config

readonly CODE_SERVER_SETTING_DIR="${HOME}"/.local/share/code-server/User/
mkdir -p "${CODE_SERVER_SETTING_DIR}"
ln -sf "${SCRIPT_DIR}"/vscode/settings.json "${CODE_SERVER_SETTING_DIR}"

readonly VSCODE_SETTING_DIR="${HOME}"/.config/Code/User/
mkdir -p "${VSCODE_SETTING_DIR}"
ln -sf "${SCRIPT_DIR}"/vscode/settings.json "${VSCODE_SETTING_DIR}"

readonly MACOS_VSCODE_SETTING_DIR="${HOME}"/Library/Application\ Support/Code/User/
mkdir -p "${MACOS_VSCODE_SETTING_DIR}"
ln -sf "${SCRIPT_DIR}"/vscode/settings.json "${MACOS_VSCODE_SETTING_DIR}"

readonly GITIGNORE_SETTING_DIR="${HOME}/.config/git/"
mkdir -p "${GITIGNORE_SETTING_DIR}"
ln -sf "${SCRIPT_DIR}/ignore" "${GITIGNORE_SETTING_DIR}"

mkdir -p ".claude"
ln -sf "${SCRIPT_DIR}/.claude/settings.json" ~/.claude/settings.json
