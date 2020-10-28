load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")

kt_jvm_binary(
    name = "deploy-maven",
    main_class = "library.ortools.DeployKt",
    srcs = ["Deploy.kt"],
)

#sh_binary(
#    name = "deploy-maven",
#    srcs = [":deploy.sh"],
#    data = [
#        # ortools-darwin
#        "@ortools_osx//:pom-runtime.xml",
#        "@ortools_osx//:ortools-darwin-8.0.8283.jar",
#        "@ortools_osx//:ortools-darwin-8.0.8283-sources.jar",
#
#        # ortools-java
#        "@ortools_osx//:pom-local.xml",
#        "@ortools_osx//:ortools-java-8.0.8283.jar",
#        "@ortools_osx//:ortools-java-8.0.8283-sources.jar",
#        "@ortools_osx//:ortools-java-8.0.8283-javadoc.jar",
#    ]
#)