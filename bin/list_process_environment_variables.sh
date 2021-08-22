#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly PID="$1"

sudo cat "/proc/${PID}/environ" | tr '\000' '\n'
