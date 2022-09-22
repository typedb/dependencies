load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def deps():
    http_archive(
        name = "io_bazel_rules_kotlin",
        urls = ["https://github.com/vaticle/rules_kotlin/archive/a73e838c2121bea9788f381b5c4d6de93cb18c74.zip"],
        type = "zip",
        strip_prefix = "rules_kotlin-a73e838c2121bea9788f381b5c4d6de93cb18c74",
        sha256 = "79826a9d857111d458e5f58555f42e9704722d1d77c7caf082dea1f33f44ef44",
    )
