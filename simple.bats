#!/usr/bin/env bats
load setup
load functions

@test "add small files" {
  cd "${WORKDIR}/trunk"
  add_small_files
}

@test "add large files" {
  cd "${WORKDIR}/trunk"
  add_large_files
}

@test "create tag" {
  create_tag "0.1.0"
}

@test "checkout filled repository" {
  cd "${WORKDIR}/trunk"

  add_small_files
  add_large_files

  cd "${WORKDIR}/.."

  rm -rf "${WORKDIR}"
  checkout
}

@test "remove branch test-1" {
  cd "${WORKDIR}/trunk"
  add_small_files

  cd "${WORKDIR}/branches"
  create_branch "test-1"

  update

  svn rm "test-1"
  svn commit -m 'removed branch test-1'
}