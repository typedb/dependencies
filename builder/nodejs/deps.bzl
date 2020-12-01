load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")

def deps():
    http_archive(
        name = "build_bazel_rules_nodejs",
        sha256 = "f2194102720e662dbf193546585d705e645314319554c6ce7e47d8b59f459e9c",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/2.2.2/rules_nodejs-2.2.2.tar.gz"],
    )
