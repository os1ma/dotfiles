#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly DOCKER_COMPOSE_VERSION='1.26.0'

readonly VISUAL_STUDIO_CODE_EXTENSIONS=(
  hashicorp.terraform
  ms-ceintl.vscode-language-pack-ja
  firsttris.vscode-jest-runner
  esbenp.prettier-vscode
  numso.prettier-standard-vscode
  arjun.swagger-viewer
  ms-vscode.vscode-typescript-tslint-plugin
  octref.vetur
  redhat.vscode-yaml
)

exist_command() {
  local command="$1"
  which "${command}" >> /dev/null
}

# Docker
curl -fsSL https://get.docker.com | bash
sudo usermod -aG docker "${USER}"

# Docker Compose
sudo curl -L \
  "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# AWS CLI version 2
sudo apt install -y unzip
if ! exist_command aws; then
  cd /tmp
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  rm awscliv2.zip
  rm -r aws
  cd -
fi

# Utility commands
sudo apt install -y jq tree

# code-server
curl -fsSL https://code-server.dev/install.sh | sh
for extension in "${VISUAL_STUDIO_CODE_EXTENSIONS[@]}"; do
  code-server --install-extension "${extension}"
done

# Gatsby
sudo apt install -y libvips-dev
yarn global add gatsby-cli
