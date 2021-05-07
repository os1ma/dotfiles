#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

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

# code-server
curl -fsSL https://code-server.dev/install.sh | sh
for extension in "${VISUAL_STUDIO_CODE_EXTENSIONS[@]}"; do
  code-server --install-extension "${extension}"
done
