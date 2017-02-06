#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/897/svn-changing-locked-file-response-contains
@test "#897 lock correct error message" {
  cd "${WORKDIR}"
  echo 'lockit' > 'trunk/lock-test.txt'
  svn add 'trunk/lock-test.txt'
  svn commit -m 'added file for lock error message test'
  svn lock 'trunk/lock-test.txt'

  checkout "${WORKDIR}/lock-check"
  cd "${WORKDIR}/lock-check"
  echo 'locked-it' >> 'trunk/lock-test.txt'
  MSG=$(svn commit -m 'changed locked file' 2>&1 || true)

  echo "${MSG}"
  echo "${MSG}" | grep 'is locked in another working copy'
}