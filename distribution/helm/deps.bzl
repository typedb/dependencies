load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "com_github_masmovil_bazel_rules",
        commit = "7bd160b5fe0354052e98b1dfb0cc6c4300b58026",
        remote = "https://github.com/masmovil/bazel-rules.git",
    )
