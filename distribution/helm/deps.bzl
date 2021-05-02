load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps():
    http_archive(
        name = "com_github_masmovil_bazel_rules",
        urls = ["https://github.com/vaticle/masmovil-bazel-rules/archive/846da589fee71012d5a8ba0102f692bf4b9a76b1.tar.gz"],
        strip_prefix = "masmovil-bazel-rules-846da589fee71012d5a8ba0102f692bf4b9a76b1",
        sha256 = "1207c2ad648ccf157951407c63cd60b8cb8d03d7ed6640123d6be5bb222bb620",
    )
