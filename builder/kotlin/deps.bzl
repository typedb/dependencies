load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def deps():
    http_archive(
        name = "io_bazel_rules_kotlin",
        urls = ["https://github.com/vaticle/rules_kotlin/archive/2b36c5a39a067613099754e6d575a48ffa3cad03.zip"],
        type = "zip",
        strip_prefix = "rules_kotlin-2b36c5a39a067613099754e6d575a48ffa3cad03",
        sha256 = "34d4d6cd39fdb7020276df0f3030fa8edf90f04a899b0560cf0154661688b7c8",
    )
