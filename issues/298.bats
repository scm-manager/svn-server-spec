#!/usr/bin/env bats
load ../setup
load ../functions

# https://bitbucket.org/sdorra/scm-manager/issues/298/the-problem-with-svn-polish-characters
@test "#298 polish characters" {
  cd "${WORKDIR}"
  tests_with_filename 'trunk/ąśćźżęł'
}