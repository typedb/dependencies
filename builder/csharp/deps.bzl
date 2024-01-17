load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def deps(use_patched_version=False):
    git_repository(
        name = "rules_dotnet",
        remote = "https://github.com/bazelbuild/rules_dotnet",
        commit = "2553afca7999fc75b808b9658dd2d1070ab56fc5",
    )