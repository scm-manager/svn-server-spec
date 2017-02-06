#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/130/lock-results-in-nosuchmethoderror
@test "#130 lock and unlock" {
  cd "${WORKDIR}"
  echo "lock/unlock" > "trunk/lock-test.txt"
  svn add "trunk/lock-test.txt"
  svn commit -m "added file for lock/unlock test"
  svn lock "trunk/lock-test.txt"
  svn unlock "trunk/lock-test.txt"
}