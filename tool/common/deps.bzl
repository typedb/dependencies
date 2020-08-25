load("@rules_python//python:pip.bzl", "pip3_import")

def graknlabs_dependencies_ci_pip():
    pip3_import(
        name = "graknlabs_dependencies_ci_pip",
        requirements = "@graknlabs_dependencies//tool:requirements.txt",
    )

maven_artifacts = [
  "com.eclipsesource.minimal-json:minimal-json",
]
