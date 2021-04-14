load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps():
    git_repository(
        name = "com_github_masmovil_bazel_rules",
        commit = "6dad38b14bcb3f060936a249763097304d50e144",
        # TODO: revert to upstream once masmovil/bazel-rules#19 is merged
        remote = "https://github.com/graknlabs/masmovil-bazel-rules.git",
    )
