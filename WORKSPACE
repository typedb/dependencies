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
load("//_build/bazel:dependencies.bzl","bazel_common", "bazel_deps", "bazel_toolchain",
     "bazel_rules_nodejs", "bazel_rules_python")
bazel_common()
bazel_deps()
bazel_toolchain()

load("//_build/bazel:dependencies.bzl", "bazel_rules_docker", "bazel_rules_nodejs", "bazel_rules_python")
bazel_rules_docker()
bazel_rules_nodejs()
bazel_rules_python()

load("@rules_python//python:pip.bzl", "pip_repositories", "pip3_import")
pip_repositories()


#################################
# Load Build Tools dependencies #
#################################

load("//_tools/checkstyle:dependencies.bzl", "checkstyle_dependencies")
checkstyle_dependencies()

load("//_tools/sonarcloud:dependencies.bzl", "sonarcloud_dependencies")
sonarcloud_dependencies()

load("//_distribution:dependencies.bzl", "graknlabs_bazel_distribution")
graknlabs_bazel_distribution()

load("@graknlabs_bazel_distribution//common:dependencies.bzl", "bazelbuild_rules_pkg")
bazelbuild_rules_pkg()

load("//grpc:dependencies.bzl", "grpc_dependencies")
grpc_dependencies()

pip3_import(
    name = "graknlabs_build_tools_ci_pip",
    requirements = "//:requirements.txt",
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

load("//_tools/unused_deps:dependencies.bzl", "unused_deps_dependencies")
unused_deps_dependencies()
