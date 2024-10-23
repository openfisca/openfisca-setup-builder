#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/string.sh'
}

# @nodoc
function test_decode_with_accented_characters() {
  actual=$(string::decode 'Valparaíso')
  assert_same 'Valparaiso' "${actual}"
}

# @nodoc
function test_decode_with_hyphens() {
  actual=$(string::decode "L'Île-d'Yeu")
  assert_same "L'Ile-d'Yeu" "${actual}"
}

# @nodoc
function test_lower_with_hyphens() {
  actual=$(string::lower "L'Île-d'Yeu")
  assert_same "l'île-d'yeu" "${actual}"
}

# @nodoc
function test_sanitise_with_special_characters() {
  actual=$(string::sanitise 'Wellington & Suburbs')
  assert_same 'Wellington  Suburbs' "${actual}"
}

# @nodoc
function test_snake_with_hyphens() {
  actual=$(string::snake "L'Île-d'Yeu")
  assert_same "L'Île_d'Yeu" "${actual}"
}

# @nodoc
function test_trim_with_spaces() {
  actual=$(string::trim 'New York')
  assert_same 'New_York' "${actual}"
}

# @nodoc
function test_trim_with_special_characters() {
  actual=$(string::trim 'Wellington & Suburbs')
  assert_same 'Wellington_&_Suburbs' "${actual}"
}
