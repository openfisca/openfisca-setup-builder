#!/bin/bash
# @name checks
# @deps utils/boolean
# @brief A package for checks and validations.

set -euo pipefail

source 'src/first_time_setup/utils/boolean.sh'

# @description Check if the script should run in non-interactive mode.
# @arg $1 The jurisdiction name.
# @arg $2 The repository URL.
is::interactive() {
  [[ -z ${1:-} || -z ${2:-} ]] && echo true || echo false
}

# @description Check if the script is running in a CI environment.
# @arg $1 The CI environment variable.
is::ci() {
  is::true "${1:-}"
}

# @description Check if the repository exists.
is::repo() {
  git rev-parse --is-inside-work-tree &>/dev/null && echo true || echo false
}

# @description Check if the setup should persevere.
# @arg $1 If we are in a CI environment.
# @arg $2 If the repository exists.
setup::persevere() {
  local -r is_ci=$(is::true "${1:-}")
  local -r is_repo=$(is::true "${2:-}")
  if ! "${is_ci}" && "${is_repo}"; then echo false; else echo true; fi
}
