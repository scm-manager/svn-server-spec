#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/136/subversion-repositories-dont-support-merge
@test "#136 merge tracking" {
  cd "${WORKDIR}"
  create_branch "merge-tracking"
  echo "merge-1" > "trunk/merge-1.txt"
  echo "merge-2" > "trunk/merge-2.txt"
  echo "merge-3" > "trunk/merge-3.txt"
  svn add trunk/merge-*
  svn commit -m "added files for merge tracking"
  cd "branches"
  svn up
  cd "merge-tracking"
  svn merge --username "${SVN_USER}" --password "${SVN_PASSWORD}" "${SVN_URL}/trunk"
  svn commit -m "merge with trunk"
}