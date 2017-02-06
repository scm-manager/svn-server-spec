#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/422/svnkit-cannot-handle-copy-request
@test "#422 create branch test-1" {
  cd "${WORKDIR}/trunk"
  add_small_files
  create_branch "test-1"
  update

  [ -d "${WORKDIR}/branches/test-1" ]
}