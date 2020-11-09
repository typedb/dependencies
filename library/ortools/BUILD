load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")
load(":deps.bzl", "version")
load("//distribution:deployment.bzl", "deployment")

# fills the deployment url and OR-Tools version with 'sed'
genrule(
    name = "deploy-generated",
    srcs = ["Deploy.template.kt"],
    outs = ["Deploy.kt"],
    cmd = "sed '{}; {}' $(SRCS) > $(OUTS)"
        .format(
            "s/{google_or_tools_version}/" + version + "/g",
            "s/{repository}/" + deployment['maven.release'].replace('/', '\/') + "/g"
        )
)

kt_jvm_binary(
    name = "deploy-maven",
    main_class = "library.ortools.DeployKt",
    srcs = [":deploy-generated"],
    deps = ["@maven//:org_zeroturnaround_zt_exec"],
    data = [
        "@google_or_tools_darwin//:pom-runtime.xml",
        "@google_or_tools_darwin//:ortools-darwin-" + version + ".jar",
        "@google_or_tools_darwin//:ortools-darwin-" + version + "-sources.jar",
        "@google_or_tools_darwin//:pom-local.xml",
        "@google_or_tools_darwin//:ortools-java-" + version + ".jar",
        "@google_or_tools_darwin//:ortools-java-" + version + "-sources.jar",
        "@google_or_tools_darwin//:ortools-java-" + version + "-javadoc.jar",

        "@google_or_tools_linux//:pom-runtime.xml",
        "@google_or_tools_linux//:ortools-linux-x86-64-" + version + ".jar",
        "@google_or_tools_linux//:ortools-linux-x86-64-" + version + "-sources.jar",
        "@google_or_tools_linux//:pom-local.xml",
        "@google_or_tools_linux//:ortools-java-" + version + ".jar",
        "@google_or_tools_linux//:ortools-java-" + version + "-sources.jar",
        "@google_or_tools_linux//:ortools-java-" + version + "-javadoc.jar",

        "@google_or_tools_windows//:pom-runtime.xml",
        "@google_or_tools_windows//:ortools-win32-x86-64-" + version + ".jar",
        "@google_or_tools_windows//:ortools-win32-x86-64-" + version + "-sources.jar",
        "@google_or_tools_windows//:pom-local.xml",
        "@google_or_tools_windows//:ortools-java-" + version + ".jar",
        "@google_or_tools_windows//:ortools-java-" + version + "-sources.jar",
        "@google_or_tools_windows//:ortools-java-" + version + "-javadoc.jar",
    ]
)
