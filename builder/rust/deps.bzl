load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def deps():
    http_archive(
        name = "rules_rust",
        sha256 = "7240a4865b11427cc58cd00b3e89c805825bfd3cc4c225b7e992a58622bec859",
        strip_prefix = "rules_rust-a619e1a30bb274639b6d2ccb76c820a02b9f94be",
        urls = [
            "https://github.com/bazelbuild/rules_rust/archive/a619e1a30bb274639b6d2ccb76c820a02b9f94be.tar.gz",
        ],
    )
    http_file(
        name = "cxxbridge_linux",
        urls = [
            "https://repo.vaticle.com/repository/meta/cxxbridge-v1.0.55-linux"
        ],
        executable = True,
    )
    http_file(
        name = "cxxbridge_mac",
        urls = [
            "https://repo.vaticle.com/repository/meta/cxxbridge-v1.0.55-mac"
        ],
        executable = True,
    )
    http_file(
        name = "cxxbridge_windows",
        urls = [
            "https://repo.vaticle.com/repository/meta/cxxbridge-v1.0.55-windows.exe",
        ],
        executable = True,
    )
