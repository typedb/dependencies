load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "rules_antlr",
        remote = "https://github.com/vaticle/rules_antlr",
        branch = "0.5.0-rust"
    )

antlr_version = "4.8.2-rust"
