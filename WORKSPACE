#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2018 Grakn Labs Ltd
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

workspace(name = "graknlabs_build_tools")

load("//bazel:dependencies.bzl","bazel_common", "bazel_deps", "bazel_toolchain",
     "bazel_rules_nodejs", "bazel_rules_python")
bazel_common()
bazel_deps()
bazel_toolchain()

load("//bazel:dependencies.bzl", "bazel_rules_docker", "bazel_rules_nodejs", "bazel_rules_python")
bazel_rules_docker()
bazel_rules_nodejs()
bazel_rules_python()

load("//bazel:dependencies.bzl", "buildifier", "buildozer", "unused_deps")
buildifier()
buildozer()
unused_deps()

load("//checkstyle:dependencies.bzl", "checkstyle_dependencies")
checkstyle_dependencies()

load("//distribution:dependencies.bzl", "graknlabs_bazel_distribution")
graknlabs_bazel_distribution()

load("//grpc:dependencies.bzl", "grpc_dependencies")
grpc_dependencies()


load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories", "pip_import")
pip_repositories()

pip_import(
    name = "graknlabs_build_tools_ci_pip",
    requirements = "//ci:requirements.txt",
)

load("@graknlabs_build_tools_ci_pip//:requirements.bzl", "pip_install")
pip_install()
