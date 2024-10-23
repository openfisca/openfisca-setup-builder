#!/bin/bash

# Ensure bashdep is installed
[[ ! -f lib/bashdep ]] && {
  mkdir -p lib
  curl -sLo lib/bashdep \
    https://github.com/Chemaclass/bashdep/releases/download/0.1/bashdep
  chmod +x lib/bashdep
}

# Add latest bashunit release to your dependencies
readonly DEPENDENCIES=(
  "https://github.com/TypedDevs/bashunit/releases/download/0.18.0/bashunit"
)

# Load, configure and run bashdep
# shellcheck disable=SC1091
source lib/bashdep
bashdep::setup dir="lib" silent=false
bashdep::install "${DEPENDENCIES[@]}"
