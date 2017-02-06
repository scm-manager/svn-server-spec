#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/22/problems-with-path-that-has-non-url
@test "#22 test files with % in its name" {

  skip "the issue seems not to be fixed yet"

  cd "${WORKDIR}"
  tests_with_filename 'trunk/Seminar%20Algorithm%20Engineering'
}