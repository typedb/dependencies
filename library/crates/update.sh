#!/usr/bin/env bash
#
# Copyright (C) 2022 Vaticle
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

# Script for regenerating BUILD files after Cargo.toml update

set -ex

[[ $(readlink $0) ]] && path=$(readlink $0) || path=$0

crates_home=$(cd "$(dirname "${path}")" && pwd -P)
pushd "$crates_home" > /dev/null
if [ ! -x cargo ]; then
    arch=$(bash --version | head -n1 | grep -o '\S\+$')  # (arch-vendor-os)
    arch=${arch#(} && arch=${arch%)} # strip parentheses
    if [[ $arch == x86_64-apple-darwin* ]]; then
        curl -o cargo https://repo.typedb.com/public/public-tools/raw/versions/1.66.0_darwin_x86_64/cargo
    elif [[ $arch == arm64-apple-darwin* ]]; then
        curl -o cargo https://repo.typedb.com/public/public-tools/raw/versions/1.66.0_darwin_arm64/cargo
    else
        echo "Unsupported architecture: $arch"
        exit 1
    fi
    chmod +x cargo
fi
./cargo generate-lockfile
popd > /dev/null
