#!/bin/bash
# @name utils/url
# @deps none
# @brief A package to extract info from a URL

set -euo pipefail

# @description Get the folder from a URL
# @arg $1 The URL
url::folder() {
  local -r url="${1}"
  local -r clean_url="${url%%[\?#]*}"
  local -r trimmed_url="${clean_url%/}"
  local -r folder="${trimmed_url##*/}"
  echo "${folder}"
}
