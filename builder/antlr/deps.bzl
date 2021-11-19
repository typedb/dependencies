load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "rules_antlr",
        remote = "https://github.com/vaticle/rules_antlr",
        commit = "1f1128d5aee1230d2188d622dac1952e4aa042b8"
    )

antlr_version = "4.8.2-rust"
