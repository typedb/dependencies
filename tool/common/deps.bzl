load("@rules_python//python:pip.bzl", "pip_install")

def graknlabs_dependencies_ci_pip():
    pip_install(
        name = "graknlabs_dependencies_ci_pip",
        requirements = "@graknlabs_dependencies//tool:requirements.txt",
    )

maven_artifacts = [
  "com.eclipsesource.minimal-json:minimal-json",
  "org.zeroturnaround:zt-exec",
  "com.google.http-client:google-http-client",
]
