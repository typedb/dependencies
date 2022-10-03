#
# Copyright (C) 2022 Vaticle
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

workspace(name = "vaticle_dependencies")

################################
# Load @vaticle_dependencies #
################################

# Load //build/rust
load("//builder/rust:deps.bzl", rust_deps = "deps")
rust_deps()
load("@rules_rust//rust:repositories.bzl", "rust_repositories")
rust_repositories(version = "nightly", iso_date = "2021-07-01", edition="2018")

# Load //builder/python
load("//builder/python:deps.bzl", python_deps = "deps")
python_deps()

# Load //builder/java
load("//builder/java:deps.bzl", java_deps = "deps")
java_deps()
load("//library/maven:rules.bzl", "maven")

# Load //builder/kotlin
load("//builder/kotlin:deps.bzl", kotlin_deps = "deps")
kotlin_deps()
load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kotlin_repositories", "kt_register_toolchains")
kotlin_repositories()
kt_register_toolchains()

# Load //library/ortools
load("//library/ortools/java:deps.bzl", "google_or_tools_mac", "google_or_tools_linux", "google_or_tools_windows")
google_or_tools_mac()
google_or_tools_linux()
google_or_tools_windows()

load("//library/ortools/cc:deps.bzl", "google_or_tools_mac", "google_or_tools_linux", "google_or_tools_windows")
google_or_tools_mac()
google_or_tools_linux()
google_or_tools_windows()

# Load //tool/common
load("//tool/common:deps.bzl", "vaticle_dependencies_ci_pip", vaticle_dependencies_tool_maven_artifacts = "maven_artifacts")
vaticle_dependencies_ci_pip()

# Load //tool/checkstyle
load("//tool/checkstyle:deps.bzl", checkstyle_deps = "deps")
checkstyle_deps()

# Load //tool/unuseddeps
load("//tool/unuseddeps:deps.bzl", unuseddeps_deps = "deps")
unuseddeps_deps()

# Load //tool/sonarcloud
load("//tool/sonarcloud:deps.bzl", "sonarcloud_dependencies")
sonarcloud_dependencies()

# Load @vaticle_bazel_distribution
load("//distribution:deps.bzl", "vaticle_bazel_distribution")
vaticle_bazel_distribution()

# Load //@vaticle_bazel_distribution//common
load("@vaticle_bazel_distribution//common:deps.bzl", "rules_pkg")
rules_pkg()
load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
rules_pkg_dependencies()

# Load Maven artifacts
maven(vaticle_dependencies_tool_maven_artifacts)

# Load Rust Crate dependencies

load("//library/crates:crates.bzl", "raze_fetch_remote_crates")
raze_fetch_remote_crates()

###############################################
# Create @vaticle_typedb_workspace_refs #
###############################################

load("@vaticle_bazel_distribution//common:rules.bzl", "workspace_refs")
workspace_refs(name = "vaticle_dependencies_workspace_refs")
