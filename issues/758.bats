#!/usr/bin/env bats
load ../setup
load ../functions

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