#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

exist_command() {
  local command="$1"
  which "${command}" >> /dev/null
}

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

# Gatsby
sudo apt install -y libvips-dev
yarn global add gatsby-cli
