#!/bin/bash
#
# TODO: Write script description
# xxx

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd)"
readonly PROJECT_HOME="${SCRIPT_DIR}"
readonly PROJECT_NAME="$(basename "$(cd "${PROJECT_HOME}"; pwd)")"

err() {
  echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2
}

for_sample() {
  local arr=('aaa', 'bbb', 'ccc')
  for e in ${arr}; do
    echo ${e}
  done
}

if_sample() {
  local cond="0"
  if [[ ${cond} ]]; then
    echo 'if'
  else
    echo 'else'
  fi
}

case_sample() {
  local expression="a"
  case "${expression}" in
    a)
      echo "${expression}"
      ;;
    absolute)
      echo "${expression}"
      ;;
    *)
      err "Unexpected expression '${expression}'"
      ;;
  esac
}

#######################################
# Main function
# Arguments:
#   None
# Returns:
#   None
#######################################
main() {
  # do something
}

main "$@"
