#!/bin/bash

# @nodoc
function set_up() {
  source 'src/first_time_setup/utils/url.sh'
}

# @nodoc
function test_url_folder() {
  actual=$(url::folder 'https://github.com/openfisca/openfisca-extension-template')
  assert_same "openfisca-extension-template" "${actual}"
}

# @nodoc
function test_url_folder_with_trailing_slash() {
  actual=$(url::folder 'https://github.com/openfisca/openfisca-extension-template/')
  assert_same "openfisca-extension-template" "${actual}"
}

# @nodoc
function test_url_folder_with_query_string() {
  actual=$(url::folder 'https://github.com/openfisca/openfisca-doc/?issues=314')
  assert_same "openfisca-doc" "${actual}"
}

# @nodoc
function test_url_folder_with_fragment() {
  actual=$(url::folder 'https://github.com/openfisca/openfisca-doc#issuecomment-123456')
  assert_same "openfisca-doc" "${actual}"
}
