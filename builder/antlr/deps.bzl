load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "rules_antlr",
        remote = "https://github.com/dmitrii-ubskii/rules_antlr",
        commit = "74ec5241f455bb7d33c74cae5e48e7361b3b0bb0"
    )

antlr_version = "4.8.2-rust"
