#!/bin/bash
# @name utils/subshell
# @deps none
# @brief A package for detecting if the script is being sourced or executed.

set -euo pipefail

# @internal
# @global BASH_SOURCE
# @global BASH_VERSION
subshell.detect() {
  local -r size="${#BASH_SOURCE[@]}"
  local -r last="${BASH_SOURCE[$((size - 1))]}"
  [[ -z ${BASH_VERSION} ]] && return 1
  [[ $0 == "${last}" ]] && echo true || echo false
}

# @description The script is being executed?
is::executed() {
  subshell.detect
}

# @description The script is being sourced?
is::sourced() {
  [[ -z $(subshell.detect) ]] && echo true || echo false
}
