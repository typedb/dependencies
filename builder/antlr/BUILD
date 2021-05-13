package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_library")

kt_jvm_library(
    name = "grammar-adapter-lib",
    srcs = ["GrammarAdapter.kt"],
    deps = [
        "@maven//:info_picocli_picocli",
    ],
    visibility = ["//visibility:public"],
)

java_binary(
    name = "grammar-adapter",
    runtime_deps = [":grammar-adapter-lib"],
    main_class = "com.vaticle.dependencies.builder.antlr.GrammarAdapterKt"
)
