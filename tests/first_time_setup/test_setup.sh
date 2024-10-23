#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/setup.sh'
}

# @nodoc
function test_setup_name_label() {
  actual=$(setup::name_label "L'Île-d'Yeu")
  assert_contains 'l-ile-d-yeu' "${actual}"
}

# @nodoc
function test_setup_name_snake() {
  actual=$(setup::name_snake "l-ile-d-yeu")
  assert_contains 'l_ile_d_yeu' "${actual}"
}

# @nodoc
function test_setup_repository_folder() {
  actual=$(setup::repository_folder "https://a.tk/o/of-l_ile/#??!!!")
  assert_contains 'of-l_ile' "${actual}"
}

# @nodoc
function test_setup_readme_lineno() {
  actual=$(setup::readme_lineno)
  assert_not_empty "${actual}"
}

# @nodoc
function test_setup_changelog_lineno() {
  actual=$(setup::changelog_lineno)
  assert_not_empty "${actual}"
}

# @nodoc
function test_setup_first_commit() {
  spy cd
  spy mv
  spy git
  setup::first_commit 'openfisca-extension-template' 'my_city' 'Hi!'
  assert_have_been_called_times 2 cd
  assert_have_been_called_with "openfisca-my_city" cd
  assert_have_been_called_times 1 mv
  assert_have_been_called_with \
    "openfisca-extension-template openfisca-my_city" mv
  assert_have_been_called_times 3 git
  assert_have_been_called_with \
    'commit --no-gpg-sign --quiet --message Hi! --author=OpenFisca Bot <bot@openfisca.org>' \
    git
}
