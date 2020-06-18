load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")

def deps():
    http_archive(
        name = "build_bazel_rules_nodejs",
        sha256 = "3b0116a8a91a75678a57ba676c246ac0fa9c90dc3d46daef305b11b54ed4467e",
        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/0.33.1/rules_nodejs-0.33.1.tar.gz"],
    )

