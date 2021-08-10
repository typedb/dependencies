load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def deps():
    http_archive(
        name = "io_bazel_rules_kotlin",
        urls = ["https://github.com/vaticle/rules_kotlin/archive/0c8f11ca602c445b7ad3298c557282e4246c723c.zip"],
        type = "zip",
        strip_prefix = "rules_kotlin-0c8f11ca602c445b7ad3298c557282e4246c723c",
        sha256 = "56b42a38b84cd157835df0c907c0db61274c63b86afb89f6f3d46ccea7653dad",
    )
