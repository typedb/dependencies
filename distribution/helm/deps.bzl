load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "com_github_masmovil_bazel_rules",
        tag = "v0.5.0",
        remote = "https://github.com/masmovil/bazel-rules.git",
    )
