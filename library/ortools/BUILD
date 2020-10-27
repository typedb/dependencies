load("@graknlabs_bazel_distribution//maven:rules.bzl", "assemble_maven", "deploy_maven")
load("@graknlabs_dependencies//distribution:deployment.bzl", "deployment")
load("@rules_jvm_external//:defs.bzl", "java_export")

java_import(
    name = "lib",
    jars = ["@ortools_osx//:ortools-darwin-8.0.8283.jar"],
    srcjar = "@ortools_osx//:ortools-darwin-8.0.8283-sources.jar",
)

java_export(
  name = "lib-deploy-maven",
  maven_coordinates = "com.google.ortools:ortools-darwin:8.0.8283",
  pom_template = "@ortools_osx//:pom-runtime.xml",  # You can omit this
  runtime_deps = [
    ":lib"
  ],
)

# assemble_maven(
#     name = "lib-assemble-maven",
#     target = ":lib",
# )

# deploy_maven(
#     name = "lib-deploy-maven",
#     target = ":lib-assemble-maven",
#     snapshot = deployment["maven.snapshot"],
#     release = deployment["maven.release"],
# )

# java_import(
#     name = "jni",
#     jars = ["@ortools_osx//:ortools-java-8.0.8283.jar"],
#     srcjar = "@ortools_osx//:ortools-java-8.0.8283-sources.jar",
#     tags = ["maven_coordinates=com.google.ortools:ortools-java:{pom_version}"],
#     deps = [":lib"]
# )

# assemble_maven(
#     name = "jni-assemble-maven",
#     target = ":jni",
# )

# deploy_maven(
#     name = "jni-deploy-maven",
#     target = ":jni-assemble-maven",
#     snapshot = deployment["maven.snapshot"],
#     release = deployment["maven.release"],
# )
