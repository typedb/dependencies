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

load("@rules_rust//crate_universe:defs.bzl", "crate", "crates_repository", "render_config")

def fetch_crates():
    crates_repository(
        name = "crates",
        cargo_lockfile = "@vaticle_dependencies//library/crates:Cargo.lock",
        manifests = ["@vaticle_dependencies//library/crates:Cargo.toml"],
        annotations = {
            "librocksdb-sys": [crate.annotation(
                build_script_env = {"ROCKSDB_LIB_DIR": "./lib"},
            )],
        },
        supported_platform_triples = [
            "aarch64-apple-darwin",
            "x86_64-apple-darwin",
            "x86_64-pc-windows-msvc",
            "x86_64-unknown-linux-gnu",
        ],
    )
