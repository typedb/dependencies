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


###########################
# Load Bazel dependencies #
###########################

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("//bazel:dependencies.bzl","bazel_common", "bazel_deps", "bazel_toolchain",
     "bazel_rules_nodejs", "bazel_rules_python")
bazel_common()
bazel_deps()
bazel_toolchain()

load("//bazel:dependencies.bzl", "buildifier", "buildozer", "unused_deps")
buildifier()
buildozer()
unused_deps()

load("//bazel:dependencies.bzl", "bazel_rules_docker", "bazel_rules_nodejs", "bazel_rules_python")
bazel_rules_docker()
bazel_rules_nodejs()
bazel_rules_python()

load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories", "pip_import")
pip_repositories()


#################################
# Load Build Tools dependencies #
#################################

load("//checkstyle:dependencies.bzl", "checkstyle_dependencies")
checkstyle_dependencies()

load("//sonarcloud:dependencies.bzl", "sonarcloud_dependencies")
sonarcloud_dependencies()

load("//distribution:dependencies.bzl", "graknlabs_bazel_distribution")
graknlabs_bazel_distribution()

load("//grpc:dependencies.bzl", "grpc_dependencies")
grpc_dependencies()

pip_import(
    name = "graknlabs_build_tools_ci_pip",
    requirements = "//ci:requirements.txt",
)

load("@graknlabs_build_tools_ci_pip//:requirements.bzl",
graknlabs_build_tools_ci_pip_install = "pip_install")
graknlabs_build_tools_ci_pip_install()

# Generate a JSON document of commit hashes of all external workspace dependencies
load("@graknlabs_bazel_distribution//common:rules.bzl", "workspace_refs")
workspace_refs(
    name = "graknlabs_build_tools_workspace_refs"
)

git_repository(
    name = "io_bazel_skydoc",
    remote = "https://github.com/graknlabs/skydoc.git",
    branch = "experimental-skydoc-allow-dep-on-bazel-tools",
)

load("@io_bazel_skydoc//:setup.bzl", "skydoc_repositories")
skydoc_repositories()

load("@io_bazel_rules_sass//:package.bzl", "rules_sass_dependencies")
rules_sass_dependencies()

load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories")
node_repositories()

load("@io_bazel_rules_sass//:defs.bzl", "sass_repositories")
sass_repositories()
