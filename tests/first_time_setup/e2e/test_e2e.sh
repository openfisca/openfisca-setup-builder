#!/bin/bash

set -euo pipefail

declare -xr DRY_MODE=true
declare -xr JURISDICTION_NAME="L'Île-d'Yeu"
declare -xr REPOSITORY_URL='https://github.com/openfisca/openfisca-ile-d_yeu'

source 'src/first_time_setup/utils/colours.sh'

result=$(./first-time-setup.sh  2>&1 1>/dev/null)

if [[ -n "${result}" ]]; then
  colour::fail 'First time setup failed with error:'
  colour::logs "${result}"
  exit 1
fi

colour::done 'First time setup ran successfully!'
