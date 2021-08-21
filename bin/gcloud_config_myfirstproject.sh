#!/bin/bash

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

readonly PROJECT_ID="$(gcloud projects list --filter 'NAME="My First Project"' --format 'value(projectId)')"
gcloud config set project "${PROJECT_ID}"
