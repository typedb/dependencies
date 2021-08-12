load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def deps():
    http_file(
        name = "org_jetbrains_compose_compiler",
        urls = ["https://maven.pkg.jetbrains.space/public/p/compose/dev/org/jetbrains/compose/compiler/compiler-hosted/1.0.0-alpha2/compiler-hosted-1.0.0-alpha2.jar"],
        sha256 = "cdf70c76d9ae44cfa1c261a74f69379446dae72580da35a415fd1ac06ed14d4c",
        downloaded_file_path = "compiler-hosted-1.0.0-alpha2.jar",
    )
