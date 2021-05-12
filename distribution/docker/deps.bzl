load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")

def deps():
    http_archive(
        name = "io_bazel_rules_docker",
        sha256 = "e9d5e14a8021f1f29981b92d189c1b10715f6d77179ade89dc658f7363701cc6",
        strip_prefix = "rules_docker-20c0025d44671df55c0b7bfc0ad649c740655185",
        urls = ["https://github.com/vaticle/rules_docker/archive/20c0025d44671df55c0b7bfc0ad649c740655185.tar.gz"],
    )
