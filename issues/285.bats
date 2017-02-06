#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/285/reintegrate-merge-fails-on-second-time
@test "#285 reintegrate merge fails on second time" {
  cd "${WORKDIR}/trunk"
  echo foo > bar.txt
  svn add bar.txt
  mkdir folder
  echo foo > folder/bar2.txt
  svn add folder/
  svn commit -m "First commit"
  cd ../branches
  create_branch "dev"
  update
  cd dev/
  echo foo > bar.txt
  echo New file >> folder/new.txt
  svn add folder/new.txt
  svn commit -m "Change in branch"
  update
  svn merge ^/trunk
  svn commit -m "Merge from trunk"
  cd ../../trunk
  update
  svn merge --reintegrate ^/branches/dev
  COUT=$(svn commit -m "Reintegrate dev branch in trunk")
  REV=$(echo $COUT | grep revision | awk '{print $3}' | sed 's/\.//g')
  cd ..
  update
  cd branches/dev
  
  # TODO
  # svn merge --record-only -c ${REV} ^/trunk
  svn merge ^/trunk

  svn commit -m "Record only merge in branch"
  echo some more text >> bar.txt
  echo third file > folder/third.txt
  svn add folder/third.txt
  svn commit -m "second edit to branch"
  svn update
  svn merge ^/trunk
  svn commit -m "Merge from trunk"
  cd ../../trunk
  update
  svn merge --reintegrate ^/branches/dev
}