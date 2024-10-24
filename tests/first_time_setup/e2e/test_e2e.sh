#!/bin/bash

test::build() {
  local -r pip_shfmt=$(command -v shfmt 2>/dev/null)
  if [[ -z ${pip_shfmt} ]]; then pip install shfmt-py 1>/dev/null; fi
  ./build.sh 1>/dev/null
}

test::run() {
  echo -e "$(./first-time-setup.sh 2>&1 1>/dev/null)"
}

main() {
  set -euo pipefail
  declare -xr DRY_MODE=true
  declare -xr JURISDICTION_NAME="L'Île-d'Yeu"
  declare -xr REPOSITORY_URL='https://github.com/openfisca/openfisca-ile-d_yeu'
  source 'src/first_time_setup/utils/colours.sh'
  test::build
  local -r result=$(test::run)

  if [[ -n ${result} ]]; then
    colour::fail 'First time setup failed with error:'
    colour::logs "${result}"
    exit 1
  fi

  colour::done 'First time setup ran successfully!'
}

main "$@"
