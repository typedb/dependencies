load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_jar")

def deps():
    http_archive(
        name = "rules_jvm_external",
        strip_prefix = "rules_jvm_external-4.3",
        sha256 = "6274687f6fc5783b589f56a2f1ed60de3ce1f99bc4e8f9edef3de43bdf7c6e74",
        url = "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/4.3.zip",
    )
