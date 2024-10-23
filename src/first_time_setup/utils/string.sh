#!/bin/bash
# @name utils/string
# @deps utils/colours
# @brief A package with utilities for string manipulation.

set -euo pipefail

source 'src/first_time_setup/utils/colours.sh'

# @internal
string.decode.a() {
  echo "${1}" | sed 'y/āáǎàâãäåĀÁǍÀÂÃÄÅ/aaaaaaaaAAAAAAAA/'
}

# @internal
string.decode.e() {
  echo "${1}" | sed 'y/ēéěèêëĒÉĚÈÊË/eeeeeeEEEEEE/'
}

# @internal
string.decode.i() {
  echo "${1}" | sed 'y/īíǐìîïĪÍǏÌÎÏ/iiiiiiIIIIII/'
}

# @internal
string.decode.o() {
  echo "${1}" | sed 'y/ōóǒòôõöŌÓǑÒÔÕÖ/oooooooOOOOOOO/'
}

# @internal
string.decode.u() {
  echo "${1}" | sed 'y/ūúǔùûüǖǘǚǜŪÚǓÙÛÜǕǗǙǛ/uuuuuuuuuuUUUUUUUUUU/'
}

# @description Convert a string to lowercase.
# @arg $1 The string to convert.
string::lower() {
  echo "${1}" | tr '[:upper:]' '[:lower:]'
}

# @description Decode a string to ASCII.
# @arg $1 The string to decode.
string::decode() {
  local string="${1}"
  local -r fx=(
    string.decode.a
    string.decode.e
    string.decode.i
    string.decode.o
    string.decode.u
  )
  local fn
  for fn in "${fx[@]}"; do string=$("${fn}" "${string}"); done
  echo "${string}"
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
