load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")

def deps(use_patched_version=False):
    if not use_patched_version:
        http_archive(
            name = "rules_python",
            url = "https://github.com/bazelbuild/rules_python/releases/download/0.1.0/rules_python-0.1.0.tar.gz",
            sha256 = "b6d46438523a3ec0f3cead544190ee13223a52f6a6765a29eae7b7cc24cc83a0",
        )
    else:
        http_archive(
            name = "rules_python",
            url = "https://github.com/graknlabs/rules_python/archive/python3-with-tensorflow-patch.tar.gz",
            strip_prefix = "rules_python-python3-with-tensorflow-patch",
            sha256 = "2ce59e824349531bbc6b0618ae18a2b6fd8b6fe3a47fce29d312c8101fdb974c",
        )
