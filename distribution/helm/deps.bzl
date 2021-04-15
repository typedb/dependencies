load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps():
    http_archive(
        name = "com_github_masmovil_bazel_rules",
        urls = ["https://github.com/masmovil/bazel-rules/archive/9c9303cbdf451c42513377f13ed3aa7fb63ca80f.tar.gz"],
        strip_prefix = "bazel-rules-9c9303cbdf451c42513377f13ed3aa7fb63ca80f",
        sha256 = "32f49873cadc625774858091c872c2500a6d80e365fca2e37a5ee573c7df9801",
    )
