load("@graknlabs_bazel_distribution//maven:rules.bzl", "assemble_maven", "deploy_maven")
load("@graknlabs_dependencies//distribution:deployment.bzl", "deployment")

java_import(
    name = "lib",
    jars = ["@ortools_osx//:ortools-darwin-8.0.8283.jar"],
    srcjar = "@ortools_osx//:ortools-darwin-8.0.8283-sources.jar",
)

sh_binary(
    name = "deploy-maven",
    srcs = [":deploy.sh"],
    data = [":pom", ":jar", ":srcjar"]
)
