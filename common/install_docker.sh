#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly DOCKER_COMPOSE_VERSION='1.26.0'

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
sudo curl -fsSL \
  "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
