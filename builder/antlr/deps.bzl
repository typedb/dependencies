load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "rules_antlr",
        remote = "https://github.com/marcohu/rules_antlr",
        commit = "89a29cca479363a5aee53e203719510bdc6be6ff"
    )

antlr_version = "4.8"
