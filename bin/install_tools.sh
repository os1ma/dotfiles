#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly DOCKER_COMPOSE_VERSION='1.26.0'

# Docker
curl -fsSL https://get.docker.com | bash

# Docker Compose
sudo curl -L \
  "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Google Chrome
curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable

# Visual Studio Code
sudo snap install --classic code
code --install-extension octref.vetur
