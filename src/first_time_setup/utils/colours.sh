#!/bin/bash
# @name utils/colours
# @deps none
# @brief A package for coloring output and messages.

set -euo pipefail

# @internal
colour.task() {
  echo -n "$(tput setaf 5)"
}

# @internal
colour.user() {
  echo -n "$(tput setaf 4)"
}

# @internal
colour.pass() {
  echo -n "$(tput setaf 6)"
}

# @internal
colour.warn() {
  echo -n "$(tput setaf 3)"
}

# @internal
colour.fail() {
  echo -n "$(tput setaf 1)"
}

# @internal
colour.done() {
  echo -n "$(tput setaf 2)"
}

# @internal
colour.info() {
  echo -n "$(tput setaf 7)"
}

# @internal
colour.logs() {
  echo -n "$(tput setaf 7)"
}

# @internal
colour.bold() {
  echo -n "$(tput bold)"
}

# @internal
colour.undl() {
  echo -n "$(tput sgr 0 1)"
}

# @internal
colour.none() {
  echo -n "$(tput sgr0)"
}

# @description Coloring task messages.
# @arg $1 string A value to colorise.
colour::task() {
  echo -e "$(colour.task)[⚙] $(colour.undl)$(colour.task)${1}$(colour.none)"
}

# @description Coloring user prompts.
# @arg $1 string A value to colorise.
colour::user() {
  echo -e "$(colour.user)[❯] ${1}$(colour.none)"
}

# @description Coloring work-in-progress operations.
# @arg $1 string A value to colorise.
colour::pass() {
  echo -e "$(colour.pass)[λ] ${1}$(colour.none)"
}

# @description Coloring warnings.
# @arg $1 string A value to colorise.
colour::warn() {
  echo -e "$(colour.warn)[!] ${1}$(colour.none)"
}

# @description Coloring failed operations.
# @arg $1 string A value to colorise.
colour::fail() {
  echo -e "$(colour.fail)[x] ${1}$(colour.none)"
}

# @description Coloring finished operations.
# @arg $1 string A value to colorise.
colour::done() {
  echo -e "$(colour.done)[✓] ${1}$(colour.none)"
}

# @description Coloring information messages.
# @arg $1 string A value to colorise.
colour::info() {
  echo -e "$(colour.info)[i] $(colour.bold)${1}$(colour.none)"
}

# @description Coloring logs.
# @arg $1 string A value to colorise.
colour::logs() {
  # shellcheck disable=SC1111
  echo -e "$(colour.logs) =  “${1}”$(colour.none)"
}
