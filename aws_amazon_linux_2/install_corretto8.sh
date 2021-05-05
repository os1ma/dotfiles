#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

sudo amazon-linux-extras enable corretto8
sudo yum install -y java-1.8.0-amazon-corretto java-1.8.0-amazon-corretto-devel
