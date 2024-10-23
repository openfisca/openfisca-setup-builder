#!/bin/bash
# @name build
# @deps utils/colours utils/subshell
# @brief Builds the script required for the first-time setup of a new OpenFisca.
# @usage bash build.sh

source 'src/first_time_setup/utils/colours.sh'
source 'src/first_time_setup/utils/subshell.sh'

# @description User interruption.
# @internal
main.trap.interrupted() {
  local -r exit_code=$?
  trap - SIGINT
  echo ''
  echo -e "$(colour::warn 'Interrupted')" >&2
  exit "${exit_code}"
}

# @description Cleanup on exit.
# @internal
main.trap.cleanup() {
  local exit_code=$?
  trap - EXIT
  rm -f "./temp.sh"
  echo -e "$(colour::info 'Exiting, bye!')"
  exit "${exit_code}"
}

# @description Build the script.
# @arg $1 The output file path.
build::main() {
  local -r out=$1
  local -r root_dir=.
  local -r temp_file="${root_dir}/temp.sh"
  local -r source_dir="${root_dir}/src/first_time_setup"
  local -r template_file="${source_dir}/main.sh"
  local f
  echo -e "$(colour::info "Building '${out}'")"
  printf '#!/bin/bash\n' >"${temp_file}"
  echo -e "$(colour::task 'Adding files...')"
  # Add utils first.
  for f in "${source_dir}"/**/*.sh; do
    build::add_file_to_temp "${f}" "${temp_file}" "${template_file}"
  done
  for f in "${source_dir}"/*.sh; do
    build::add_file_to_temp "${f}" "${temp_file}" "${template_file}"
  done
  echo -e "$(colour::done 'Files added...')"
  echo -e "$(colour::task 'Applying template...')"
  build::apply_template "${template_file}" "${temp_file}" "${out}"
  echo -e "$(colour::done 'Template applied...')"
  echo -e "$(colour::done 'Copied to dist folder...')"
  mkdir -p "${root_dir}/dist"
  cp -f "${out}" "${root_dir}/dist/${out}"
  echo -e "$(colour::info 'Building complete :)')"
}

# @description Function to add a file's content to the temporary file.
# @arg $1 The file path.
# @arg $2 The temporary file path.
# @arg $3 The template file path.
build::add_file_to_temp() {
  if [[ ${1} != "${3}" ]]; then
    echo -e "$(colour::pass "Adding ${1}...")"
    tail -n +7 "${1}" >>"${2}"
  fi
}

# @description Function to apply the template (main) to the output file.
# @arg $1 The template file path.
# @arg $2 The temporary file path.
# @arg $3 The output file path.
build::apply_template() {
  tail -n +5 "${1}" >>"${2}"
  echo -e "$(colour::pass "Remove lines starting with 'source'")"
  grep -v '^source' "${2}" >"${3}"
  echo -e "$(colour::pass 'Make the output file executable')"
  chmod u+x "${3}"
  echo -e "$(colour::pass 'Formatting the output file')"
  if command -v poetry &>/dev/null; then
    poetry run shfmt --write --simplify "${3}"
  else
    shfmt --write --simplify "${3}"
  fi
}

# Main function.
main() {
  # Exit immediately if a command exits with a non-zero status.
  set -o errexit
  # Ensure that the ERR trap is inherited by shell functions.
  set -o errtrace
  # More verbosity when something within a function fails.
  set -o functrace
  # Treat unset variables as an error and exit immediately.
  set -o nounset
  # Prevent errors in a pipeline from being masked.
  set -o pipefail
  # Make word splitting happen only on newlines and tab characters.
  IFS=$'\n\t'

  # Define a cleanup functions to be called on script exit or interruption.
  trap main.trap.interrupted SIGINT
  trap main.trap.cleanup EXIT

  # Make sure we are not being sourced. Exit if it is the case.
  if "$(is::sourced)"; then
    main.error 'This script should not be sourced but executed directly'
    exit 1
  fi

  # Support being called from anywhere on the file system.
  cd "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

  # Call the build function with the first argument.
  build::main "$1"
}

main "first-time-setup.sh"
