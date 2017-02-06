#!/bin/bash

function setup {
  if [ -d "${WORKDIR}" ]; then
    rm -rf "${WORKDIR}"
  fi

  if [ -d "${REPOSITORY_PATH}" ]; then
    rm -rf "${REPOSITORY_PATH}"
  fi

  sh $JSVNADMIN create "${REPOSITORY_PATH}"
  checkout

  cd "${WORKDIR}"

  # create basic structure
  svn mkdir trunk tags branches
  svn commit -m 'added structure'
}

function create_tag {
  echo "creating tag ${1}"
  svn copy "${SVN_URL}/trunk" "${SVN_URL}/tags/${1}" -m "create tag ${1}"
}

function create_branch {
  echo "creating branch ${1}"
  svn copy "${SVN_URL}/trunk" "${SVN_URL}/branches/${1}" -m "create branch ${1}"
}

function checkout {
  CHECKOUTDIR="${1}"
  if [ "x${CHECKOUTDIR}" = "x" ]; then
    CHECKOUTDIR="${WORKDIR}"
  fi
  svn co "${SVN_URL}" "${CHECKOUTDIR}"
}

function update {
  svn update "${WORKDIR}"
}

function tests_with_filename {
  FILENAME="${1}"
  uuidgen > "${FILENAME}.txt"
  svn add "${FILENAME}.txt"
  svn commit -m "added file ${FILENAME}.txt"
  uuidgen > "${FILENAME}.txt"
  svn commit -m "changed file ${FILENAME}.txt"
  svn copy "${FILENAME}.txt" "${FILENAME} copy.txt"
  svn commit -m "copy file {FILENAME}.txt to {FILENAME} copy.txt"
  svn rm "${FILENAME} copy.txt"
  svn commit -m "remove file ${FILENAME} copy.txt"
  svn move "${FILENAME}.txt" "${FILENAME} move.txt"
  svn commit -m "move file ${FILENAME}.txt to ${FILENAME} move.txt"
  svn rm "${FILENAME} move.txt"
  svn commit -m "removed ${FILENAME} move.txt"
}

function add_small_files {
 for x in $(bash -c "echo {a..${SMALLFILES_END}}")
  do
    echo "${x}" > "${x}.txt"
    svn add "${x}.txt"
    svn commit -m "added ${x}"
  done
}

function add_large_files {
  for x in $(seq 1 "${LARGEFILES_END}")
  do
    echo "adding large-file-${x}"
    dd if=/dev/random of="large-file-${x}.bin" bs="${x}M" count=1
    svn add "large-file-${x}.bin"
    svn commit -m "added large-file-${x}"
  done
}