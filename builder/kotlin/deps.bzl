load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def deps():
    http_archive(
        name = "io_bazel_rules_kotlin",
        urls = ["https://github.com/vaticle/rules_kotlin/archive/2275dfc628bca44f110faf9e321158529176cb82.zip"],
        type = "zip",
        strip_prefix = "rules_kotlin-2275dfc628bca44f110faf9e321158529176cb82",
        sha256 = "012d3a835ff045c86a9666917b64bb5ff52b89bdd16d2ba983f9bf98d3fd167b",
    )
