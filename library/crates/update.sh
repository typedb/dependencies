#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


# Script for regenerating BUILD files after Cargo.toml update

set -ex

[[ $(readlink $0) ]] && path=$(readlink $0) || path=$0

crates_home=$(cd "$(dirname "${path}")" && pwd -P)
pushd "$crates_home" > /dev/null
./get_cargo.sh
./cargo generate-lockfile
popd > /dev/null
