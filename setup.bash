#!/bin/bash
BASEDIR=$(pwd)
SVN_URL="http://localhost:9090/svnkit-dav/dav"
SVN_USER="admin"
SVN_PASSWORD="admin"
REPOSITORY_PATH="/tmp/repos/dav"
JSVNADMIN="/home/ssdorra/Projects/bitbucket/svnkit-mq/svnkit-distribution/build/all/svnkit-1.8.5-scm4-SNAPSHOT_t20170206_0838/bin/jsvnadmin"
WORKDIR="${BASEDIR}/work"

SMALLFILES_END="c"
LARGEFILES_END=3
