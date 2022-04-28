#!/usr/bin/env bats
load ../setup
load ../functions

# https://github.com/scm-manager/scm-manager/issues/2002
@test "#2002 test files with spaces" {
  cd "${WORKDIR}/trunk"
  echo "some content" > "file with space.txt"
  svn add "file with space.txt"
  svn commit -m "added file with space"

  echo "more content" >> "file with space.txt"
  svn commit -m "changed file with space"

  ${SVNKITMQ}/svnkit-distribution/build/all/svnkit-*/bin/jsvn diff -r 2:3 "${SVN_URL}/trunk@3"
}
