#!/bin/bash
# @name messages
# @deps envvars
# @brief A package for setting the messages used by the setup script.

set -euo pipefail

source 'src/first_time_setup/envvars.sh'

# @description Define the welcome message.
msg::welcome() {
  local -r version='0.1.1'
  cat <<MSG
Welcome to the OpenFisca Extension Template setup script v${version}!

This script will guide you through the process of setting up a new OpenFisca
jurisdiction from start to finish. We will begin now...
MSG
}

# @description Define the ci/repo validation message.
msg::stop() {
  cat <<MSG
It seems you cloned this repository, or already initialised it. Refusing to go
    further as you might lose work. If you are certain this is a new repository,
    run 'cd "${ROOT_PATH}" && rm -rf .git' to erase the history.
MSG
}

# @description Define the prompt for the jurisdiction name.
msg::prompt_name() {
  cat <<MSG
The name of the jurisdiction (usually a city or a region, e.g. Île-d'Yeu,
    Val-d'Isère...) you will model the rules of:
MSG
}

# @description Define the prompt for the url of the repository.
msg::prompt_url() {
  cat <<MSG
Your Git repository URL (i.e.
    https://githost.example/organisation/openfisca-jurisdiction):
MSG
}

# @description Define the message whether to continue or not.
msg::prompt_continue() {
  cat <<MSG
Would you like to continue (type Y for yes, N for no):
MSG
}

# @description Define the good bye message.
msg::goodbye() {
  cat <<MSG
The setup script has finished. You can now start writing your legislation with
    OpenFisca 🎉. Happy rules-as-coding!
MSG
}

# @description Define the byebye message.
# @arg $1 The jurisdiction label.
msg::byebye() {
  cat <<MSG
Bootstrap complete, you can now push this codebase to your remote repository.

    First, set up the remote with 'git remote add origin <SSH repository URL>'.
    You can then 'git push origin main' and refer to the README.md.
    The parent directory name has been changed, you can use
    'cd ../openfisca-${1} to navigate to it.
MSG
}

# @description Define the message for when running in dry mode.
msg::dry_mode() {
  cat <<MSG
»skipping the next step as we are running in dry mode«
MSG
}
