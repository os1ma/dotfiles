#!/bin/bash
#
# see https://stackoverflow.com/questions/16124877/how-do-you-hide-the-address-bar-in-google-chrome-for-chrome-apps/20663518#20663518

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

URL="$1"

'/Applications/Google Chrome.app/Contents/MacOS/Google Chrome' --app="${URL}"
