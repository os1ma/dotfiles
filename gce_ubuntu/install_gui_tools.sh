#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

# Google Chrome
curl https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install -y google-chrome-stable

# Visual Studio Code
sudo snap install --classic code
code --install-extension octref.vetur

# IntelliJ IDEA
sudo snap install intellij-idea-community --classic
