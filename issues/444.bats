#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/444/using-space-or-in-svn-resource-name-does
@test "#444 test files with spaces in its name" {
  cd "${WORKDIR}"
  tests_with_filename 'trunk/file with some spaces in it'
}

# https://bitbucket.org/sdorra/scm-manager/issues/444/using-space-or-in-svn-resource-name-does
@test "#444 test files with ! in its name" {
  cd "${WORKDIR}"
  tests_with_filename 'trunk/file with a ! in it'
}