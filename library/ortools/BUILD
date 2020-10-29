load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")

kt_jvm_binary(
    name = "deploy-maven",
    main_class = "library.ortools.DeployKt",
    srcs = ["Deploy.kt"],
    deps = ["@maven//:org_zeroturnaround_zt_exec"],
    data = [
        # ortools-darwin
        "@google_ortools_osx//:pom-runtime.xml",
        "@google_ortools_osx//:ortools-darwin-8.0.8283.jar",
        "@google_ortools_osx//:ortools-darwin-8.0.8283-sources.jar",

        # ortools-java
        "@google_ortools_osx//:pom-local.xml",
        "@google_ortools_osx//:ortools-java-8.0.8283.jar",
        "@google_ortools_osx//:ortools-java-8.0.8283-sources.jar",
        "@google_ortools_osx//:ortools-java-8.0.8283-javadoc.jar",
    ]
)