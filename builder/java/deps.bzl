load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_jar")

def deps():
    http_archive(
        name = "rules_jvm_external",
        strip_prefix = "rules_jvm_external-3.2",
        sha256 = "82262ff4223c5fda6fb7ff8bd63db8131b51b413d26eb49e3131037e79e324af",
        url = "https://github.com/bazelbuild/rules_jvm_external/archive/refs/tags/3.2.zip",
    )
