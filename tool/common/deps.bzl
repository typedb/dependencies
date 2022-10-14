load("@rules_python//python:pip.bzl", "pip_install")

def vaticle_dependencies_ci_pip():
    pip_install(
        name = "vaticle_dependencies_ci_pip",
        requirements = "@vaticle_dependencies//tool:requirements.txt",
    )

maven_artifacts = [
  "com.eclipsesource.minimal-json:minimal-json",
  "com.electronwill.night-config:core",
  "com.electronwill.night-config:toml",
  "com.google.http-client:google-http-client",
  "org.zeroturnaround:zt-exec",
  "info.picocli:picocli",
]
