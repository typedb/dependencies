package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_kotlin//kotlin:core.bzl", "kt_compiler_plugin")

kt_compiler_plugin(
    name = "compiler_plugin",
    id = "jetbrains.compose.compiler",
    target_embedded_compiler = True,
    deps = [
        "@maven//:org_jetbrains_compose_compiler_compiler",
    ],
     visibility = ["//visibility:public"],
)