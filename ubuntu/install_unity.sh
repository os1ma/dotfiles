#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

sudo apt install -y p7zip-full libgconf-2-4

# Install Unity Hub
sudo curl -L \
  https://public-cdn.cloud.unity3d.com/hub/prod/UnityHub.AppImage \
  -o /usr/local/bin/UnityHub.AppImage
sudo chmod +x /usr/local/bin/UnityHub.AppImage
