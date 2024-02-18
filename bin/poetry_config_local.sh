#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

poetry config --local virtualenvs.in-project true
poetry config --local virtualenvs.prefer-active-python true
