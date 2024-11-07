# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("@rules_rust//rust:defs.bzl", "rust_library")
load("//tool/checkstyle:rules.bzl", "checkstyle_test")
load("//builder/rust:rules.bzl", "rust_cxx_bridge")

package(default_visibility = ["//visibility:public"])

rust_library(
    name = "ortools",
    srcs = ["ortools.rs"],
    deps = [
        "@crates//:cxx",
        ":ortools_bridge",
    ]
)

rust_cxx_bridge(
    name = "ortools_bridge",
    src = "ortools.rs",
    deps = select({
        "@typedb_bazel_distribution//platform:is_mac": [
            "@or_tools_mac//:lib",
            "@or_tools_mac//:incl",
        ],
        "@typedb_bazel_distribution//platform:is_linux": [
            "@or_tools_linux//:lib",
            "@or_tools_linux//:incl",
        ],
        "@typedb_bazel_distribution//platform:is_windows": [
            "@or_tools_windows//:lib",
            "@or_tools_windows//:incl",
        ],
    }) + [":ortools_bridge_wrapper"],
)

cc_library(
    name = "ortools_bridge_wrapper",
    hdrs = ["OrToolsWrapper.h"],
    deps = select({
        "@typedb_bazel_distribution//platform:is_mac": [
            "@or_tools_mac//:lib",
            "@or_tools_mac//:incl",
        ],
        "@typedb_bazel_distribution//platform:is_linux": [
            "@or_tools_linux//:lib",
            "@or_tools_linux//:incl",
        ],
        "@typedb_bazel_distribution//platform:is_windows": [
            "@or_tools_windows//:lib",
            "@or_tools_windows//:incl",
        ],
    })
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "mpl-header",
    size = "small",
)
