#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

code-server --auth none ${@:-.}
