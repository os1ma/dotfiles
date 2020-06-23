#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly TMUX_SESSIONS="$(tmux ls | cut -d ':' -f1)"

for s in ${TMUX_SESSIONS}; do
  tmux kill-session -t "${s}"
done

cat <<EOT
==================================
Kill all tmux session SUCCEEDED!!!
==================================
EOT
