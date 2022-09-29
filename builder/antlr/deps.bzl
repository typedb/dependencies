load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "rules_antlr",
        remote = "https://github.com/vaticle/rules_antlr",
        commit = "d64bb89db42e669b096c310b6b5f62e1565e1375"
    )

antlr_version = "4.8.2-rust"
