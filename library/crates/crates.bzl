#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@rules_rust//crate_universe:deps_bootstrap.bzl", "cargo_bazel_bootstrap")
load("@rules_rust//crate_universe:defs.bzl", "crate", "crates_repository", "render_config")

def fetch_crates():
    crates_repository(
        name = "crates",
        cargo_lockfile = "@vaticle_dependencies//library/crates:Cargo.lock",
        manifests = ["@vaticle_dependencies//library/crates:Cargo.toml"],
        annotations = {
            "cbindgen": [crate.annotation(gen_binaries = True)],
        },
        supported_platform_triples = [
            "aarch64-apple-darwin",
            "aarch64-unknown-linux-gnu",
            "x86_64-apple-darwin",
            "x86_64-pc-windows-msvc",
            "x86_64-unknown-linux-gnu",
        ],
    )
