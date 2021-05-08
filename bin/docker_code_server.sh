#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

docker run \
  -it \
  -p 8080:8080 \
  -v "$PWD:/home/coder/project" \
  -u "$(id -u):$(id -g)" \
  -e "DOCKER_USER=$USER" \
  codercom/code-server:latest
