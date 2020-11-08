load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")
load(":deps.bzl", "version")

kt_jvm_binary(
    name = "deploy-maven",
    main_class = "library.ortools.DeployKt",
    srcs = ["Deploy.kt"],
    deps = ["@maven//:org_zeroturnaround_zt_exec"],
    data = [
        # ortools-darwin
        "@google_or_tools_darwin//:pom-runtime.xml",
        "@google_or_tools_darwin//:ortools-darwin-" + version + ".jar",
        "@google_or_tools_darwin//:ortools-darwin-" + version + "-sources.jar",

        # ortools-java
        "@google_or_tools_darwin//:pom-local.xml",
        "@google_or_tools_darwin//:ortools-java-" + version + ".jar",
        "@google_or_tools_darwin//:ortools-java-" + version + "-sources.jar",
        "@google_or_tools_darwin//:ortools-java-" + version + "-javadoc.jar",

        # ortools-linux
        "@google_or_tools_linux//:pom-runtime.xml",
        "@google_or_tools_linux//:ortools-linux-x86-64-" + version + ".jar",
        "@google_or_tools_linux//:ortools-linux-x86-64-" + version + "-sources.jar",

        # ortools-windows
        "@google_or_tools_windows//:pom-runtime.xml",
        "@google_or_tools_windows//:ortools-win32-x86-64-" + version + ".jar",
        "@google_or_tools_windows//:ortools-win32-x86-64-" + version + "-sources.jar",
    ]
)

# TODO: deploy-maven-mac
# TODO: deploy-maven-linux
# TODO: deploy-maven-windows