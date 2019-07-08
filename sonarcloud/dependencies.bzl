load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def sonarcloud_dependencies():
    http_file(
        name = "sonarscanner_zip",
        urls = ["http://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/3.3.0.1492/sonar-scanner-cli-3.3.0.1492.zip"]
    )