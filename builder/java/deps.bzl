load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_jar")

def deps():
    http_archive(
        name = "rules_jvm_external",
        strip_prefix = "rules_jvm_external-5.2",
        sha256 = "3824ac95d9edf8465c7a42b7fcb88a5c6b85d2bac0e98b941ba13f235216f313",
        url = "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/5.2.zip",
    )
