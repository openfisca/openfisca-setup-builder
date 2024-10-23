#!/bin/bash
# @name utils/string
# @deps utils/colours
# @brief A package with utilities for string manipulation.

set -euo pipefail

source 'src/first_time_setup/utils/colours.sh'

# @internal
# @arg $1 The error message.
string.error() {
  echo -e "$(colour::fail "${1}")" >&2
  return 1
}

# @internal
string.unidecode.find() {
  local pip poetry
  pip=$(command -v unidecode 2>/dev/null)
  poetry=$(poetry run which unidecode 2>/dev/null)
  [[ -n ${pip} ]] && echo "${pip}" && return
  [[ -n ${poetry} ]] && echo "${poetry}" && return
  string.error "Unidecode not found. Install it with 'pip install unidecode'."
  return 1
}

# @description Convert a string to lowercase.
# @arg $1 The string to convert.
string::lower() {
  echo "${1}" | tr '[:upper:]' '[:lower:]'
}

# @description Decode a string to ASCII.
# @arg $1 The string to decode.
string::decode() {
  local -r unidecode=$(string.unidecode.find)
  [[ -z ${unidecode} ]] && return 1
  echo "${1}" | "${unidecode}"
}

# @description Remove special characters from a string.
# @arg $1 The string to clean.
string::sanitise() {
  echo "${1}" |
    sed -r 's/[\"'\''«»“”„‟‹›]+/-/g' |
    sed -r 's/[^a-zA-Z _-]+//g'
}

# @description Remove spaces from a string.
# @arg $1 The string to clean.
string::trim() {
  echo "${1}" | sed -r 's/[ ]+/_/g'
}

# @description Convert a string to snake case.
# @arg $1 The string to convert.
string::snake() {
  echo "${1}" | sed -r 's/[-]+/_/g'
}
