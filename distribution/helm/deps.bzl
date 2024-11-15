# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def com_github_masmovil_bazel_rules():
    git_repository(
        name = "com_github_masmovil_bazel_rules",
        tag = "v0.5.0",
        remote = "https://github.com/masmovil/bazel-rules.git",
    )
