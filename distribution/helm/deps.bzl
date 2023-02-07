load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps():
    http_archive(
        name = "com_github_masmovil_bazel_rules",
        urls = ["https://github.com/vaticle/masmovil-bazel-rules/archive/refs/tags/2023-02-06-vaticle.tar.gz"],
        strip_prefix = "masmovil-bazel-rules-2023-02-06-vaticle",
        sha256 = "b8963e51cadf3418ac935b2dad85aeed98c7769d8a7364649cdfb9ecce92cd5a",
    )
