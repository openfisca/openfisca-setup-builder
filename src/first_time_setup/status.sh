#!/bin/bash
# @name status
# @deps utils/colours
# @brief Gives the status of the setup.

set -euo pipefail

source 'src/first_time_setup/utils/colours.sh'

# @description Gather information from environment variables.
# @arg $1 The jurisdiction name.
# @arg $2 The repository URL.
# @arg $3 If it is an interactive mode.
status::gather_info() {
  echo ''
  colour::task 'Gathering environment variables'
  echo ''
  colour::pass "Jurisdiction name:"
  colour::logs "${1:-[unset]}"
  colour::pass 'Repository URL:'
  colour::logs "${2:-[unset]}"
  colour::pass 'Interactive mode (inferred):'
  colour::logs "${3}"
}

# @description Check if we can continue.
# @arg $1 If we are in a CI environment.
# @arg $2 If the repository exists.
# @arg $3 If the setup should persevere.
# @arg $4 If the setup should be dry.
status::check_continue() {
  echo ''
  colour::task 'Checking if we can continue'
  echo ''
  colour::pass 'Are we in a CI environment?'
  colour::logs "${1}"
  colour::pass 'Is there an existing repository already?'
  colour::logs "${2}"
  if "${3}" || "${4}"; then
    colour::pass 'Can the setup continue?'
    colour::logs "${3}"
    if "${4}"; then
      colour::warn '»persevering because the setup is being run in dry mode«'
    fi
  else
    colour::warn 'Can the setup continue?'
    colour::logs "${3}"
  fi
}

# @description Print a pre-setup summary.
# @arg $1 The jurisdiction name.
# @arg $2 The jurisdiction name snake.
# @arg $3 The repository URL.
status::pre_summary() {
  echo ''
  colour::done 'Jurisdiction title set to:'
  colour::logs "${1:-[unset]}"
  colour::done 'Jurisdiction Python label set to:'
  colour::logs "${2:-[unset]}"
  colour::done 'Git repository URL set to:'
  colour::logs "${3:-[unset]}"
}
