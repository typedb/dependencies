#!/usr/bin/env bash
set -e

MISSING_VARIABLE=false

if [ -z $ARTIFACT_USERNAME ]; then echo "ARTIFACT_USERNAME is not set."; MISSING_VARIABLE=true; fi;
if [ -z $ARTIFACT_PASSWORD ]; then echo "ARTIFACT_PASSWORD is not set."; MISSING_VARIABLE=true; fi;

if [ $MISSING_VARIABLE = true ]; then exit 1; fi;

cat >> ${HOME}/.netrc <<EOF

machine repo.typedb.com
        login $ARTIFACT_USERNAME
        password $ARTIFACT_PASSWORD

EOF
