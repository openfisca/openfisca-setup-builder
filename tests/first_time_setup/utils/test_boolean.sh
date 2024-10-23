#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/boolean.sh'
}

# @nodoc
function test_is_false_when_empty() {
  actual=$(is::false)
  assert_true "${actual}"
}

# @nodoc
function test_is_false_when_blank() {
  actual=$(is::false '')
  assert_true "${actual}"
}

# @nodoc
function test_is_false_when_zero() {
  actual=$(is::false 0)
  assert_true "${actual}"
}

# @nodoc
function test_is_false_when_false() {
  actual=$(is::false 'false')
  assert_true "${actual}"
}

# @nodoc
function test_is_false_when_n() {
  actual=$(is::false 'n')
  assert_true "${actual}"
}

# @nodoc
function test_is_false_when_no() {
  actual=$(is::false 'NO')
  assert_true "${actual}"
}

# @nodoc
function test_is_true() {
  actual=$(is::true 1)
  assert_true "${actual}"
}
