load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def deps():
    rules_kotlin_version = "1.7.0-RC-3"
    rules_kotlin_sha = "f033fa36f51073eae224f18428d9493966e67c27387728b6be2ebbdae43f140e"

    http_archive(
        name = "io_bazel_rules_kotlin",
        urls = ["https://github.com/bazelbuild/rules_kotlin/releases/download/v%s/rules_kotlin_release.tgz" % rules_kotlin_version],
        sha256 = rules_kotlin_sha,
    )
