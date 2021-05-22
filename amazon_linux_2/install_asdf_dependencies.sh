#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

# Ruby
sudo yum install -y gcc bzip2 openssl-devel libyaml-devel libffi-devel \
  readline-devel zlib-devel gdbm-devel ncurses-devel
