#
# Copyright (C) 2020 Grakn Labs
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

workspace(name = "graknlabs_dependencies")

################################
# Load @graknlabs_dependencies #
################################

# Load //builder/python
load("//builder/python:deps.bzl", python_deps = "deps")
python_deps()

load("@rules_python//python:pip.bzl", "pip_repositories")
pip_repositories()

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
load("//library/ortools/deploy:deps.bzl", "google_or_tools_darwin", "google_or_tools_linux", "google_or_tools_windows")
google_or_tools_darwin()
google_or_tools_linux()
google_or_tools_windows()

# Load //tool/common
load("//tool/common:deps.bzl", "graknlabs_dependencies_ci_pip")
graknlabs_dependencies_ci_pip()
load("@graknlabs_dependencies_ci_pip//:requirements.bzl",graknlabs_dependencies_ci_pip_install = "pip_install")
graknlabs_dependencies_ci_pip_install()

# Load //tool/checkstyle
load("//tool/checkstyle:deps.bzl", checkstyle_deps = "deps")
checkstyle_deps()

# Load //tool/unuseddeps
load("//tool/unuseddeps:deps.bzl", unuseddeps_deps = "deps")
unuseddeps_deps()

# Load //tool/sonarcloud
load("//tool/sonarcloud:deps.bzl", "sonarcloud_dependencies")
sonarcloud_dependencies()

# Load @graknlabs_bazel_distribution
load("//distribution:deps.bzl", "graknlabs_bazel_distribution")
graknlabs_bazel_distribution()

# Load //@graknlabs_bazel_distribution//common
load("@graknlabs_bazel_distribution//common:deps.bzl", "rules_pkg")
rules_pkg()
load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
rules_pkg_dependencies()

# Load Maven artifacts
maven(["org.zeroturnaround:zt-exec", "com.eclipsesource.minimal-json:minimal-json"])
