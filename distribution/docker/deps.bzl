load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")

def deps():
    http_archive(
        name = "io_bazel_rules_docker",
        sha256 = "14ac30773fdb393ddec90e158c9ec7ebb3f8a4fd533ec2abbfd8789ad81a284b",
        strip_prefix = "rules_docker-0.12.1",
        urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.12.1/rules_docker-v0.12.1.tar.gz"],
    )