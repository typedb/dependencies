# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@rules_rust//rust:defs.bzl", "rust_binary")
load("@vaticle_dependencies//tool/checkstyle:rules.bzl", "checkstyle_test")

rust_binary(
    name = "compile",
    srcs = ["compile.rs"],
    deps = ["@crates//:tonic-build"],
    visibility = ["//visibility:public"]
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "mpl-header",
    size = "small",
)
