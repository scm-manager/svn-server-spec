#!/bin/bash -e

function absolutepath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

BASEDIR=$(pwd)

if [[ "${SPEC_TYPE}" = "svnkit-mq" || "${SPEC_TYPE}" = "" ]]; then
    SPEC_TYPE="svnkit-mq"

    if [ "${SVNKITMQ}" = "" ]; then
        SVNKITMQ=$(absolutepath ~/Projects/scm-manager/svnkit-mq)
    fi

    if [ ! -d "${SVNKITMQ}" ]; then
        echo "ERROR: could not find svnkit-mq"
        echo "please clone it from https://bitbucket.org/sdorra/svnkit-mq/"
        echo "apply all patches, build it (./gradlew build -xtest -xjavadoc) and" 
        echo "start svnkit-dav (./gradlew svnkit-dav:serveDav)."
        echo "Set SVNKITMQ environment variable to the clone directory."
        exit 1
    fi

    JSVNADMIN="$(absolutepath ${SVNKITMQ}/svnkit-distribution/build/all/svnkit-*/bin/jsvnadmin || echo "")"
    if [ "${JSVNADMIN}" = "" ]; then
        echo "ERROR: could not find jsvnadmin"
        echo "be sure you have build the whole distribution (./gradlew build -xtest -xjavadoc)"
        exit 2
    fi

    SVN_URL="http://localhost:9090/svnkit-dav/dav"
    SVN_USER="admin"
    SVN_PASSWORD="admin"

    if ! curl -u "${SVN_USER}:${SVN_PASSWORD}" "${SVN_URL}" >/dev/null 2>&1; then
        echo "ERROR: svnkit-dav is not reachable"
        echo "be sure you have start it (./gradlew svnkit-dav:serveDav)."
        exit 3
    fi


    REPOSITORY_PATH="/tmp/repos/dav"

elif [ "${SPEC_TYPE}" = "scm" ]; then
    REPOSITORY_NAME="sspec"
    SVN_URL="http://localhost:8081/scm/svn/${REPOSITORY_NAME}"
    SVN_USER="scmadmin"
    SVN_PASSWORD="scmadmin"

    if [ "${SCMCLI}" = "" ]; then
        echo "ERROR: could not find scm-cli-client"
        echo "please set the SCMCLI environment variable to the jar"
        exit 4
    fi

    if [ ! -f "${SCMCLI}" ]; then
        echo "ERROR: could not find scm-cli-client at ${SCMCLI}"
        echo "please set the SCMCLI environment variable to the jar"
        exit 5
    fi

    export SCM_CLI_CLIENT="java -jar ${SCMCLI} -s http://localhost:8081/scm -u scmadmin -p scmadmin"
fi

WORKDIR="${BASEDIR}/work"

SMALLFILES_END="c"
LARGEFILES_END=3

# override svn command and attach username and password
alias svn="$(which svn) --username ${SVN_USER} --password ${SVN_PASSWORD}"