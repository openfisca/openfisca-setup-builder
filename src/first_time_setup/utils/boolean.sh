#!/bin/bash
# @name utils/boolean
# @deps none
# @brief A package to check if a value is a boolean.

set -euo pipefail

# @description Check if a value is false.
# @arg $1 The value to check.
is::false() {
  case "${1:-}" in
  '' | 0 | [Nn] | [Nn][Oo] | [Ff][Aa][Ll][Ss][Ee]) echo true ;;
  *) echo false ;;
  esac
}

# @description Check if a value is true.
# @arg $1 The value to check.
is::true() {
  [[ $(is::false "${1}") == 'false' ]] && echo true || echo false
}
