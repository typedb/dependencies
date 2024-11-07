# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps(use_patched_version=False):
    http_archive(
        name = "rules_python",
        sha256 = "c6fb25d0ba0246f6d5bd820dd0b2e66b339ccc510242fd4956b9a639b548d113",
        strip_prefix = "rules_python-0.37.2",
        url = "https://github.com/bazelbuild/rules_python/releases/download/0.37.2/rules_python-0.37.2.tar.gz",
    )
