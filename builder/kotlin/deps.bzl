load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def deps():
    http_archive(
        name = "io_bazel_rules_kotlin",
        urls = ["https://github.com/jamesreprise/rules_kotlin/archive/a30f94e82d0b4ca439612a634ef7f62f13c56dc2.zip"],
        type = "zip",
        strip_prefix = "rules_kotlin-a30f94e82d0b4ca439612a634ef7f62f13c56dc2",
        sha256 = "aa48a3d7859db8a72ab019ebd2ee71e41ea429b0e7f3216c7599fc4ff9dc74a9",
    )
