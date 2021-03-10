#!/usr/bin/env bash

set -e
[[ $(readlink $0) ]] && path=$(readlink $0) || path=$0
WAIT_FOR_HOST_HOME=$(cd "$(dirname "${path}")" && pwd -P)
exec java -jar $WAIT_FOR_HOST_HOME/wait-for-host.jar $*
