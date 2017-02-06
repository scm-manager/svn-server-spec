#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/358/svn-copy-and-move-failed-svn-e175002
@test "#358 move and copy branches" {
  cd "${WORKDIR}/trunk"
  add_small_files

  cd "${WORKDIR}/branches"
  create_branch "test-1"
  svn up
  svn move test-1 test-2
  svn copy test-2 test-3
  svn commit -m 'move and copy branches around'
}