load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")

def rules_python(use_patched_version=False):
    if not use_patched_version:
        http_archive(
            name = "rules_python",
            url = "https://github.com/bazelbuild/rules_python/releases/download/0.0.2/rules_python-0.0.2.tar.gz",
            strip_prefix = "rules_python-0.0.2",
            sha256 = "b5668cde8bb6e3515057ef465a35ad712214962f0b3a314e551204266c7be90c",
        )
    else:
        http_archive(
            name = "rules_python",
            url = "https://github.com/graknlabs/rules_python/archive/python3-with-tensorflow-patch.tar.gz",
            strip_prefix = "rules_python-python3-with-tensorflow-patch",
            sha256 = "2ce59e824349531bbc6b0618ae18a2b6fd8b6fe3a47fce29d312c8101fdb974c",
        )
