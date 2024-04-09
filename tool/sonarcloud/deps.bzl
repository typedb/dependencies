# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def sonarcloud_dependencies():
    select({
        "@vaticle_bazel_distribution//platform:is_mac":http_file(
            name = "sonarscanner_zip",
            urls = ["https://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/5.0.1.3006/sonar-scanner-cli-5.0.1.3006-macosx.zip"]
        ),
        "@vaticle_bazel_distribution//platform:is_linux":http_file(
            name = "sonarscanner_zip",
            urls = ["https://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/5.0.1.3006/sonar-scanner-cli-5.0.1.3006-linux.zip"]
        ),
        "//conditions:default": http_file(
            name = "sonarscanner_zip",
            urls = ["https://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/5.0.1.3006/sonar-scanner-cli-5.0.1.3006.zip"]
        ),
    })
