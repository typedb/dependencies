load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "rules_antlr",
        remote = "https://github.com/marcohu/rules_antlr",
        tag = "0.5.0"
    )

antlr_version = "4.7.2"
