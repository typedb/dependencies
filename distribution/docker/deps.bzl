load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")

def deps():
    http_archive(
        name = "io_bazel_rules_docker",
        sha256 = "8987c47e480a6ec7628a99159dc5da8d4a9b5367b31ac3aaecbee954ee37f75c",
        strip_prefix = "rules_docker-9d5735a1da710a645b2863f9ebba58bba51ad09c",
        urls = ["https://github.com/vaticle/rules_docker/archive/9d5735a1da710a645b2863f9ebba58bba51ad09c.tar.gz"],
    )
