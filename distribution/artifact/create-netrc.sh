#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
