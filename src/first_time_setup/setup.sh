#!/bin/bash
# @name setup
# @deps utils/file utils/string utils/url
# @brief Functions for setting up the new package.

set -euo pipefail

source 'src/first_time_setup/utils/file.sh'
source 'src/first_time_setup/utils/string.sh'
source 'src/first_time_setup/utils/url.sh'

# @description Set up the jurisdiction name label
# @arg $1 The jurisdiction name.
setup::name_label() {
  local name="${1}"
  local -r fx=(string::decode string::lower string::sanitise string::trim)
  local fn
  for fn in "${fx[@]}"; do name=$("${fn}" "${name}"); done
  echo "${name}"
}

# @description Snake case the jurisdiction name.
# @arg $1 The jurisdiction name label.
setup::name_snake() {
  string::snake "${1}"
}

# @description Get the repository folder.
# @arg $1 The repository URL.
setup::repository_folder() {
  url::folder "${1}"
}

# @description Get the last line number of the bootstrapping section.
setup::readme_lineno() {
  file::find_lineno README.md '## Writing the Legislation'
}

# @description Get the last line number of the changelog section.
setup::changelog_lineno() {
  file::find_lineno CHANGELOG.md '# Example Entry'
}

# @description First commit.
# @arg $1 The parent folder.
# @arg $2 The setup name label.
# @arg $3 The first commit message.
# @arg $4 If we are running in dry mode.
setup::first_commit() {
  if "${4:-false}"; then return; fi
  cd ..
  mv "${1}" openfisca-"${2}"
  cd openfisca-"${2}"
  git init --initial-branch=main &>/dev/null 2>&1
  git add .
  git commit --no-gpg-sign --quiet --message "${3}" \
    --author='OpenFisca Bot <bot@openfisca.org>'
}

# @description Replace default extension_template references
# Use intermediate backup files (`-i`) with a weird syntax due to lack of
# portable 'no backup' option. See: https://stackoverflow.com/q/5694228/594053.
# @arg $1 The jurisdiction name label.
# @arg $2 The jurisdiction snake cased.
# @arg $3 The normal jurisdiction name.
# @arg $4 The list of files to replace.
# @arg $5 If we are running in dry mode.
setup::replace_references() {
  if "${5:-false}"; then return; fi
  sed -i.template "s|openfisca-extension_template|openfisca-${1}|g" \
    README.md Taskfile.yaml pyproject.toml CONTRIBUTING.md
  # shellcheck disable=SC2086
  sed -i.template "s|extension_template|${2}|g" \
    README.md pyproject.toml Taskfile.yaml MANIFEST.in ${4}
  sed -i.template "s|Extension-Template|${3}|g" \
    README.md pyproject.toml .github/PULL_REQUEST_TEMPLATE.md CONTRIBUTING.md
  find . -name "*.template" -type f -delete
}

# @description Remove bootstrap instructions.
# @arg $1 The last line number of the bootstrapping section in the README.md.
# @arg $2 If we are running in dry mode.
setup::remove_bootstrap_instructions() {
  if "${2:-false}"; then return; fi
  sed -i.template -e "3,${1}d" README.md
  find . -name "*.template" -type f -delete
}

# @description Prepare README.md and CONTRIBUTING.md.
# @arg $1 The repository URL.
# @arg $2 If we are running in dry mode.
setup::prepare_readme_contributing() {
  if "${2:-false}"; then return; fi
  sed -i.template "s|https://example.com/repository|${1}|g" \
    README.md CONTRIBUTING.md
  find . -name "*.template" -type f -delete
}

# @description Prepare CHANGELOG.md.
# @arg $1 The last line number of the changelog section in the CHANGELOG.md.
# @arg $2 If we are running in dry mode.
setup::prepare_changelog() {
  if "${2:-false}"; then return; fi
  sed -i.template -e "1,${1}d" CHANGELOG.md
  find . -name "*.template" -type f -delete
}

# @description Prepare pyproject.toml.
# @arg $1 The repository URL.
# @arg $2 The repository folder.
# @arg $3 If we are running in dry mode.
setup::prepare_pyproject() {
  if "${3:-false}"; then return; fi
  sed -i.template \
    "s|https://github.com/openfisca/extension-template|${1}|g" \
    pyproject.toml
  sed -i.template 's|:: 5 - Production/Stable|:: 1 - Planning|g' pyproject.toml
  sed -i.template 's|^version = "[0-9.]*"|version = "0.0.1"|g' pyproject.toml
  sed -i.template "s|repository_folder|${2}|g" README.md
  find . -name "*.template" -type f -delete
}

# @description Rename the package.
# @arg $1 The new package name.
# @arg $2 If we are running in dry mode.
setup::rename_package() {
  if "${2:-false}"; then return; fi
  git mv openfisca_extension_template "${1}"
}

# Remove single use first time setup files
# @arg $1 If we are running in dry mode.
setup::remove_files() {
  if "${1:-false}"; then return; fi
  git rm .github/workflows/first-time-setup.yml &>/dev/null 2>&1
  git rm bashdep.sh &>/dev/null 2>&1
  git rm build.sh &>/dev/null 2>&1
  git rm first-time-setup.sh &>/dev/null 2>&1
  git rm -r src/first_time_setup &>/dev/null 2>&1
  git rm -r tests/first_time_setup &>/dev/null 2>&1
}

# @description Second commit and first tag.
# @arg $1 The second commit message.
# @arg $2 If we are running in dry mode.
setup::second_commit() {
  if "${2:-false}"; then return; fi
  git add .
  git commit --no-gpg-sign --quiet --message "${1}" \
    --author='OpenFisca Bot <bot@openfisca.org>'
  git tag '0.0.1'
}
