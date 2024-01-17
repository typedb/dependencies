load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps(use_patched_version=False):
    http_archive(
        name = "rules_dotnet",
        sha256 = "09021aa1d8a63395cd072e384cd560612e713f35a448da43a7e89087787aadc0",
        strip_prefix = "rules_dotnet-0.13.0",
        url = "https://github.com/bazelbuild/rules_dotnet/releases/download/v0.13.0/rules_dotnet-v0.13.0.tar.gz",
    )