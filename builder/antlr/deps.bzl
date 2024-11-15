# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def rules_antlr():
    git_repository(
        name = "rules_antlr",
        remote = "https://github.com/marcohu/rules_antlr",
        commit = "89a29cca479363a5aee53e203719510bdc6be6ff"
    )

antlr_version = "4.8"
