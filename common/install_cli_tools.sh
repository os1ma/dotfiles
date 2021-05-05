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
  vscjava.vscode-java-pack
  gabrielbb.vscode-lombok
  toba.vsfire
  mathiasfrohlich.kotlin
)

# 参考: https://get.docker.com
get_distribution() {
  lsb_dist=""
  if [ -r /etc/os-release ]; then
    lsb_dist="$(. /etc/os-release && echo "$ID")"
  fi
  echo "$lsb_dist"
}

is_amzn() {
  [ "$(get_distribution)" = 'amzn' ]
}

install_docker() {
  if is_amzn; then
    sudo yum install -y docker
    sudo systemctl enable docker
    sudo systemctl start docker
  else
    curl -fsSL https://get.docker.com | bash
  fi
}

# Docker
install_docker
sudo usermod -aG docker "${USER}"

# Docker Compose
sudo curl -L \
  "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# code-server
curl -fsSL https://code-server.dev/install.sh | sh
for extension in "${VISUAL_STUDIO_CODE_EXTENSIONS[@]}"; do
  code-server --install-extension "${extension}"
done
