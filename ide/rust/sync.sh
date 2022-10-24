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

set -e
cd "$BUILD_WORKSPACE_DIRECTORY"
export RUST_TARGETS=$(bazel query 'kind(rust_*, //...)' | tr '\n' ' ')
bazel build $RUST_TARGETS
bazel build $RUST_TARGETS --aspects @vaticle_dependencies//ide/rust:sync_aspect.bzl%rust_ide_sync_aspect --output_groups=rust-ide-sync
bazel run @vaticle_dependencies//ide/rust:generate_cargo_manifests -- --workspace_root="$(bazel info workspace)" --bazel_output_base="$(bazel info output_base)"
