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

cargo_target=@rules_rust//rust/toolchain:current_cargo_files

bazel build $cargo_target

project_dir=$(bazel info workspace)
cargo_relpath=$(bazel cquery $cargo_target --output starlark --starlark:expr="target.files.to_list()[0].path" 2>/dev/null)
cargo=${project_dir}/${cargo_relpath}

crates_home=$(cd "$(dirname "${path}")" && pwd -P)
pushd "$crates_home" > /dev/null
$cargo generate-lockfile
popd > /dev/null
