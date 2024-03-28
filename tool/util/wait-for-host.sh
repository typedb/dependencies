#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -e
[[ $(readlink $0) ]] && path=$(readlink $0) || path=$0
WAIT_FOR_HOST_HOME=$(cd "$(dirname "${path}")" && pwd -P)
exec java -jar $WAIT_FOR_HOST_HOME/wait-for-host.jar $*
