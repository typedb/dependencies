load("@graknlabs_dependencies//distribution:deployment.bzl", "deployment")

sh_binary(
    name = "deploy-maven",
    srcs = [":deploy.sh"],
    data = [
        # ortools-darwin
        "@ortools_osx//:pom-runtime.xml",
        "@ortools_osx//:ortools-darwin-8.0.8283.jar",
        "@ortools_osx//:ortools-darwin-8.0.8283-sources.jar",

        # ortools-java
        "@ortools_osx//:pom-local.xml",
        "@ortools_osx//:ortools-java-8.0.8283.jar",
        "@ortools_osx//:ortools-java-8.0.8283-sources.jar",
        "@ortools_osx//:ortools-java-8.0.8283-javadoc.jar",
    ]
)
