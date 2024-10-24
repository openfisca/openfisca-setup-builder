#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/file.sh'
}

# @nodoc
function test_find_lineno() {
  path=$(mktemp -d)
  : >"${path}/file"
  echo 'line 1' >"${path}/file"
  echo 'line 2' >>"${path}/file"
  actual=$(file::find_lineno "${path}/file" 'line 2')
  assert_same 2 "${actual}"
  rm -f "${path}/file"
  rmdir "${path}"
}

# @nodoc
function test_find_lineno_when_not_found() {
  path=$(mktemp -d)
  : >"${path}/file"
  echo 'line 1' >"${path}/file"
  actual=$(file::find_lineno "${path}/file" 'line 2')
  assert_same -1 "${actual}"
  rm -f "${path}/file"
  rmdir "${path}"
}
