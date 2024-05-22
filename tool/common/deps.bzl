# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("@rules_python//python:pip.bzl", "pip_parse")

def vaticle_dependencies_ci_pip(python_interpreter_target=None):
    pip_parse(
        name = "vaticle_dependencies_ci_pip",
        requirements_lock = "@vaticle_dependencies//tool:requirements.txt",
        python_interpreter_target = python_interpreter_target
    )

maven_artifacts = [
  "com.eclipsesource.minimal-json:minimal-json",
  "com.electronwill.night-config:core",
  "com.electronwill.night-config:toml",
  "com.fasterxml.jackson.core:jackson-core",
  "com.fasterxml.jackson.core:jackson-databind",
  "com.google.http-client:google-http-client",
  "com.vdurmont:semver4j",
  "commons-io:commons-io",
  "info.picocli:picocli",
  "org.jetbrains.compose.compiler:compiler",
  "org.jsoup:jsoup",
  "org.kohsuke:github-api",
  "org.zeroturnaround:zt-exec",
]
