#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/checks.sh'
}

# @nodoc
function test_is_interactive() {
  actual=$(is::interactive)
  assert_true "${actual}"
}

# @nodoc
function test_is_interactive_when_one_is_set() {
  actual=$(is::interactive 'Paris')
  assert_true "${actual}"
}

# @nodoc
function test_is_interactive_when_both_are_set() {
  actual=$(is::interactive 'Paris' 'https://git.paris.fr/openfisca')
  assert_false "${actual}"
}

# @nodoc
function test_is_ci() {
  actual=$(is::ci 'true')
  assert_true "${actual}"
}

# @nodoc
function test_is_ci_when_set_to_false() {
  actual=$(is::ci false)
  assert_false "${actual}"
}

# @nodoc
function test_is_ci_when_set_to_zero() {
  actual=$(is::ci 0)
  assert_false "${actual}"
}

# @nodoc
function test_is_ci_when_empty() {
  actual=$(is::ci '')
  assert_false "${actual}"
}

# @nodoc
function test_is_ci_when_not_set() {
  actual=$(is::ci)
  assert_false "${actual}"
}

# @nodoc
function test_is_repo() {
  mock git true
  actual=$(is::repo)
  assert_true "${actual}"
}

# @nodoc
function test_is_repo_when_it_is_not() {
  mock git false
  actual=$(is::repo)
  assert_false "${actual}"
}

# @nodoc
function test_setup_persevere() {
  actual=$(setup::persevere 'True' 'no')
  assert_true "${actual}"
}

# @nodoc
function test_setup_persevere_when_not_in_ci() {
  mock git false
  actual=$(setup::persevere 'False' 'N')
  assert_true "${actual}"
}

# @nodoc
function test_setup_persevere_when_repo_exists() {
  actual=$(setup::persevere '1' 'y')
  assert_true "${actual}"

}

# @nodoc
function test_setup_persevere_when_not_in_ci_and_repo_exists() {
  actual=$(setup::persevere 'No' 'Yes')
  assert_false "${actual}"
}
