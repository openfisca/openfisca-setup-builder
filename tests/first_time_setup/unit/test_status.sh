#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/status.sh'
}

# @nodoc
function test_status_gather_info() {
  actual=$(status::gather_info 'Paris' 'https://git.paris.fr/openfisca' 'true')
  assert_contains 'Paris' "${actual}"
}

# @nodoc
function test_status_check_continue() {
  actual=$(status::check_continue 'true' 'false' 'true' 'false')
  assert_contains 'true' "${actual}"
}

# @nodoc
function test_status_check_continue_when_not_persevere() {
  actual=$(status::check_continue 'false' 'true' 'false' 'false')
  assert_contains 'true' "${actual}"
}

# @nodoc
function test_status_check_continue_when_dry_run() {
  actual=$(status::check_continue 'false' 'true' 'false' 'true')
  assert_contains 'the setup is being run in dry mode' "${actual}"
}

# @nodoc
function test_status_pre_summary() {
  actual=$(status::pre_summary "Île-d'Yeu" 'ile_d-yeu' 'https://a.tk/o/of-l_ile')
  assert_contains "Île-d'Yeu" "${actual}"
}
