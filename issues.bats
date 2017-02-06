#!/usr/bin/env bats
load setup
load functions

# https://bitbucket.org/sdorra/scm-manager/issues/422/svnkit-cannot-handle-copy-request
@test "#422 create branch test-1" {
  cd "${WORKDIR}/trunk"
  add_small_files
  create_branch "test-1"
  update

  [ -d "${WORKDIR}/branches/test-1" ]
}


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

# https://bitbucket.org/sdorra/scm-manager/issues/758/svn-update-fails-on-large-xml-file
@test "#758 test large xml files" {
  cd "${WORKDIR}"

  cp ../resources/*_orig.xml trunk/
  svn add trunk/*_orig.xml
  svn commit -m 'added large xml file'

  cp ../resources/large-001.xml trunk/*_orig.xml
  svn commit -m 'change large xml file'

  cp ../resources/*_orig.xml trunk/*_orig.xml
  svn commit -m 'change large xml file again'

  create_branch "test-4"
  svn up
}

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

# https://bitbucket.org/sdorra/scm-manager/issues/22/problems-with-path-that-has-non-url
@test "#22 test files with % in its name" {

  skip "the issue seems not to be fixed yet"

  cd "${WORKDIR}"
  tests_with_filename 'trunk/Seminar%20Algorithm%20Engineering'
}

# https://bitbucket.org/sdorra/scm-manager/issues/298/the-problem-with-svn-polish-characters
@test "#298 polish characters" {

  skip "the issue seems not to be fixed yet"

  cd "${WORKDIR}"
  tests_with_filename 'trunk/ąśćźżęł'
}

# https://bitbucket.org/sdorra/scm-manager/issues/606/subversion-fails-to-commit-filenames
@test "#606 tests url-encoded character \"/\"" {

  skip "the issue seems not to be fixed yet"

  cd "${WORKDIR}"
  tests_with_filename 'trunk/ugly%2Ffilename'
}

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

# https://bitbucket.org/sdorra/scm-manager/issues/130/lock-results-in-nosuchmethoderror
@test "#130 lock and unlock" {
  cd "${WORKDIR}"
  echo "lock/unlock" > "trunk/lock-test.txt"
  svn add "trunk/lock-test.txt"
  svn commit -m "added file for lock/unlock test"
  svn lock "trunk/lock-test.txt"
  svn unlock "trunk/lock-test.txt"
}

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