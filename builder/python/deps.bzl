# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps(use_patched_version=False):
    http_archive(
        name = "rules_python",
        sha256 = "c68bdc4fbec25de5b5493b8819cfc877c4ea299c0dcb15c244c5a00208cde311",
        strip_prefix = "rules_python-0.31.0",
        url = "https://github.com/bazelbuild/rules_python/releases/download/0.31.0/rules_python-0.31.0.tar.gz",
    )
