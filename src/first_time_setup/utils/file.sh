#!/bin/bash
# @name utils/file
# @deps none
# @brief A package for finding things in files.

set -euo pipefail

# @description Get the line number of a text in a file.
# @arg $1 The file to read.
# @arg $2 The text to search for.
file::find_lineno() {
  local lineno=0
  local line
  while IFS= read -r line || [[ -n ${line} ]]; do
    ((lineno++))
    if [[ ${line} == "${2}" ]]; then
      echo "${lineno}"
      return
    fi
  done <"${1}"
  echo -1
}
