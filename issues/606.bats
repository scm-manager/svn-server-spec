#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/606/subversion-fails-to-commit-filenames
@test "#606 tests url-encoded character \"/\"" {
  cd "${WORKDIR}"
  tests_with_filename 'trunk/ugly%2Ffilename'
}
