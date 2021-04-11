#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly DOCKER_COMPOSE_VERSION='1.26.0'

# Docker
sudo yum install -y docker
sudo systemctl start docker
sudo usermod -aG docker "${USER}"

# Docker Compose
sudo curl -L \
  "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
