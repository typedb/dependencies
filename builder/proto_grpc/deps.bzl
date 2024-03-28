# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps():
    deps_rules_proto_grpc()
    deps_grpc()

def deps_rules_proto_grpc():
    git_repository(
       name = "rules_proto_grpc",
       remote = "https://github.com/rules-proto-grpc/rules_proto_grpc",
       commit = "7064b28a75b3feb014b20d3276e17498987a68e2"
    )

def deps_grpc():
    http_archive(
        name = "com_github_grpc_grpc",
        sha256 = "79e3ff93f7fa3c8433e2165f2550fa14889fce147c15d9828531cbfc7ad11e01",
        strip_prefix = "grpc-1.54.1",
        urls = ["https://github.com/grpc/grpc/archive/v1.54.1.tar.gz"],
    )
