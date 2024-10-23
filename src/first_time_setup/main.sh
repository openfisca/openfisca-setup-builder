#!/bin/bash
# @name main
# @deps checks envvars messages setup status utils/*
# @brief Setup a new OpenFisca extension package.

source 'src/first_time_setup/utils/boolean.sh'
source 'src/first_time_setup/utils/colours.sh'
source 'src/first_time_setup/utils/file.sh'
source 'src/first_time_setup/utils/string.sh'
source 'src/first_time_setup/utils/subshell.sh'
source 'src/first_time_setup/utils/url.sh'
source 'src/first_time_setup/checks.sh'
source 'src/first_time_setup/envvars.sh'
source 'src/first_time_setup/messages.sh'
source 'src/first_time_setup/setup.sh'
source 'src/first_time_setup/status.sh'

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
  echo -e "$(colour::info 'Exiting, bye!')"
  exit "${exit_code}"
}

# @description Generic error message.
# @arg $1 The message to display.
# @internal
main.error() {
  local -r message="${1}"
  echo -e "$(colour::fail "${message}")" >&2
}

# @description Main function to drive the script.
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
  cd "${ROOT_PATH}"

  # Define the variables we will use.
  local name="${JURISDICTION_NAME}"
  local url="${REPOSITORY_URL}"
  local -r interactive=$(is::interactive "${name}" "${url}")
  local -r ci=$(is::ci "${CI}")
  local -r repo=$(is::repo)
  local -r persevere="$(setup::persevere "${ci}" "${repo}")"
  local -r dry=$(is::true "${DRY_MODE}")
  local -r module='openfisca_extension_template'
  local -r first_commit='Initial import from OpenFisca-Extension_Template'
  local -r second_commit='Customise extension_template through script'

  # Check if we can continue.
  colour::info "$(msg::welcome)"
  status::gather_info "${name}" "${url}" "${interactive}"
  status::check_continue "${ci}" "${repo}" "${persevere}" "${dry}"
  if ! "${persevere}" && ! "${dry}"; then
    echo ''
    main.error "$(msg::stop)"
    echo ''
    exit 2
  fi

  echo ''
  colour::task 'We will now start setting up your new package'

  # Process the jurisdiction name.
  if [[ -z ${name} ]]; then echo ''; fi
  while [[ -z ${name} ]]; do
    echo -e -n "$(colour::user "$(msg::prompt_name)")"
    IFS= read -r -p ' ' name
  done
  readonly name
  local -r label=$(setup::name_label "${name}")
  local -r snake=$(setup::name_snake "${label}")

  # Process the repository URL.
  if [[ -z ${url} ]]; then echo ''; fi
  while [[ -z ${url} ]]; do
    echo -e -n "$(colour::user "$(msg::prompt_url)")"
    IFS= read -r -p ' ' url
  done
  readonly url
  local -r folder=$(setup::repository_folder "${url}")

  status::pre_summary "${name}" "${snake}" "${url}"

  # Shall we proceed?
  echo ''
  local continue=$(is::false "${interactive}")
  local prompt=$(colour::user "$(msg::prompt_continue)")
  if "${continue}"; then echo -e "${prompt} Y"; fi
  while ! "${continue}"; do
    echo -e -n "${prompt}"
    IFS= read -r -p ' ' continue
    continue=$(is::true "${continue}")
    if ! "${continue}"; then break; fi
  done
  unset prompt
  readonly continue
  echo -e "$(colour::logs "${continue}")"
  if ! "${continue}"; then echo '' && exit 3; fi

  echo ''
  colour::task 'Now we can proceed with the setup'

  local -r package="openfisca_${snake}"
  local -r lineno_readme=$(setup::readme_lineno)
  if [[ ${lineno_readme} -eq -1 ]]; then
    echo ''
    main.error 'Could not find the last line number of the README.md section'
    echo ''
    exit 4
  fi
  local -r lineno_changelog=$(setup::changelog_lineno)
  if [[ ${lineno_changelog} -eq -1 ]]; then
    echo ''
    main.error 'Could not find the last line number of the CHANGELOG.md section'
    echo ''
    exit 5
  fi

  # Initialise the repository.
  if ! "${ci}" || "${dry}"; then
    echo ''
    colour::pass 'Initialise git repository...'
    if ! "${dry}"; then
      setup::init_repository "${ROOT_DIR}" "${label}" "${first_commit}"
    else
      colour::warn 'Skipping git repository initialisation because of dry run'
    fi
    colour::pass "Commit made to 'main' with message:"
    colour::logs "${first_commit}"
  fi

  # And go on...
  colour::pass 'Replace default extension_template references'
  local -r files=$(git ls-files "src/${module}")
  setup::replace_references "${label}" "${snake}" "${name}" "${files}"
  colour::pass 'Remove bootstrap instructions'
  setup::remove_bootstrap_instructions "${lineno_readme}"
  colour::pass 'Prepare README.md and CONTRIBUTING.md'
  setup::prepare_readme_contributing "${url}"
  colour::pass 'Prepare CHANGELOG.md'
  setup::prepare_changelog "${lineno_changelog}"
  colour::pass 'Prepare pyproject.toml'
  setup::prepare_pyproject "${url}" "${folder}"
  colour::pass 'Rename package to:'
  colour::logs "${package}"
  if ! "${dry}"; then
    setup::rename_package "${package}"
  else
    colour::warn 'Skipping renaming of package because of dry run'
  fi
  colour::pass 'Remove single use first time setup files'
  if ! "${dry}"; then
    setup::remove_files
  else
    colour::warn 'Skipping removal of first time setup files because of dry run'
  fi

  # Committing and tagging take directly place in the GitHub Actions workflow.
  if "${ci}"; then
    echo ''
    colour::done "$(msg::goodbye)"
    echo ''
    exit 0
  fi

  # Second commit and first tag.
  colour::pass 'Committing and tagging...'
  if ! "${dry}"; then
    setup::second_commit "${second_commit}"
  else
    colour::warn 'Skipping committing and tagging because of dry run'
  fi
  colour::pass "Second commit and first tag made on 'main' branch:"
  colour::logs "${second_commit}"

  # And finish! :)
  echo ''
  colour::done "$(msg::byebye "${label}")"
  echo ''
}

main "$@"
