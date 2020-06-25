load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "rules_antlr",
        remote = "https://github.com/graknlabs/rules_antlr",
        commit = "8fd16b2900ebf6b893c2b7695850960dcc2d102c"
    )
