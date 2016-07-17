#!/bin/bash
function create_tag {
  echo "creating tag ${1}"
  svn copy --username "${SVN_USER}" --password "${SVN_PASSWORD}" \
    "${SVN_URL}/trunk" "${SVN_URL}/tags/${1}" -m "create tag ${1}"
}

function create_branch {
  echo "creating branch ${1}"
  svn copy --username "${SVN_USER}" --password "${SVN_PASSWORD}" \
    "${SVN_URL}/trunk" "${SVN_URL}/branches/${1}" -m "create branch ${1}"
}

function checkout {
  svn co --username "${SVN_USER}" --password "${SVN_PASSWORD}" "${SVN_URL}" "${WORKDIR}"
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
  svn commit -m 'move file ${FILENAME}.txt to ${FILENAME} move.txt'
  svn rm "${FILENAME} move.txt"
  svn commit -m 'removed ${FILENAME} move.txt'
}
