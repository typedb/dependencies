load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps(use_patched_version=False):
    if not use_patched_version:
        http_archive(
            name = "rules_python",
            sha256 = "9fcf91dbcc31fde6d1edb15f117246d912c33c36f44cf681976bd886538deba6",
            strip_prefix = "rules_python-0.8.0",
            url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.0.tar.gz",
        )
    else:
        http_archive(
            name = "rules_python",
            url = "https://github.com/vaticle/rules_python/archive/python3-with-tensorflow-patch.tar.gz",
            strip_prefix = "rules_python-python3-with-tensorflow-patch",
            sha256 = "2ce59e824349531bbc6b0618ae18a2b6fd8b6fe3a47fce29d312c8101fdb974c",
        )
