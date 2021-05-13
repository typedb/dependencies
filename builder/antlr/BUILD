package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_library")

kt_jvm_library(
    name = "grammar-converter-lib",
    srcs = ["GrammarConverter.kt"],
    deps = [
        "@maven//:info_picocli_picocli",
    ],
    visibility = ["//visibility:public"],
)

java_binary(
    name = "grammar-converter",
    runtime_deps = [":grammar-converter-lib"],
    main_class = "com.vaticle.dependencies.builder.antlr.GrammarConverterKt"
)
