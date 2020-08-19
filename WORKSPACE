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
# Load Antlr
load("//builder/antlr:deps.bzl", antlr_deps = "deps")
antlr_deps()
load("@rules_antlr//antlr:deps.bzl", "antlr_dependencies")
antlr_dependencies()

# Load Bazel
load("//builder/bazel:deps.bzl", "bazel_toolchain")
bazel_toolchain()

# Load gRPC
load("//builder/grpc:deps.bzl", grpc_deps = "deps")
grpc_deps()
load("@com_github_grpc_grpc//bazel:grpc_deps.bzl",
com_github_grpc_grpc_deps = "grpc_deps")
com_github_grpc_grpc_deps()
load("@stackb_rules_proto//java:deps.bzl", "java_grpc_compile")
java_grpc_compile()
load("@stackb_rules_proto//node:deps.bzl", "node_grpc_compile")
node_grpc_compile()

# Load Java
load("//builder/java:deps.bzl", java_deps = "deps")
java_deps()
load("//library/maven:rules.bzl", "maven")

# Load Kotlin
load("//builder/kotlin:deps.bzl", kotlin_deps = "deps")
kotlin_deps()
load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kotlin_repositories", "kt_register_toolchains")
kotlin_repositories()
kt_register_toolchains()

# Load NodeJS
load("//builder/nodejs:deps.bzl", nodejs_deps = "deps")
nodejs_deps()
load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories")
node_repositories()
load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories", "yarn_install")

# Load Python
load("//builder/python:deps.bzl", python_deps = "deps")
python_deps()
load("@rules_python//python:pip.bzl", "pip_repositories", "pip3_import")
pip_repositories()
pip3_import(
    name = "graknlabs_dependencies_ci_pip",
    requirements = "//tool:requirements.txt",
)
load("@graknlabs_dependencies_ci_pip//:requirements.bzl",
graknlabs_dependencies_ci_pip_install = "pip_install")
graknlabs_dependencies_ci_pip_install()

# Load Docker
load("//distribution/docker:deps.bzl", docker_deps = "deps")
docker_deps()

# Load Checkstyle
load("//tool/checkstyle:deps.bzl", checkstyle_deps = "deps")
checkstyle_deps()

# Load Sonarcloud
load("//tool/sonarcloud:deps.bzl", "sonarcloud_dependencies")
sonarcloud_dependencies()

# Load Unused Deps
load("//tool/unuseddeps:deps.bzl", unuseddeps_deps = "deps")
unuseddeps_deps()

# Load Kotlin Build Deps
load("//dependencies/maven:artifacts.bzl", graknlabs_dependencies_artifacts = "artifacts")

######################################
# Load @graknlabs_bazel_distribution #
######################################
load("//dependencies/graknlabs:repositories.bzl", "graknlabs_bazel_distribution")
graknlabs_bazel_distribution()

# Load Apt and RPM
load("@graknlabs_bazel_distribution//common:dependencies.bzl", "bazelbuild_rules_pkg")
bazelbuild_rules_pkg()
load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
rules_pkg_dependencies()

# Load Docker
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
git_repository(
    name = "io_bazel_skydoc",
    remote = "https://github.com/graknlabs/skydoc.git",
    branch = "experimental-skydoc-allow-dep-on-bazel-tools",
)
load("@io_bazel_skydoc//:setup.bzl", "skydoc_repositories")
skydoc_repositories()
load("@io_bazel_rules_sass//:package.bzl", "rules_sass_dependencies")
rules_sass_dependencies()
load("@io_bazel_rules_sass//:defs.bzl", "sass_repositories")
sass_repositories()

# Load Github
load("@graknlabs_bazel_distribution//github:dependencies.bzl", "tcnksm_ghr")
tcnksm_ghr()

# Load NodeJS
load("@build_bazel_rules_nodejs//:defs.bzl", "node_repositories")
node_repositories()

# Load Python
git_repository(
    name = "io_bazel_rules_python",
    remote = "https://github.com/bazelbuild/rules_python.git",
    commit = "fdbb17a4118a1728d19e638a5291b4c4266ea5b8",
)
load("@io_bazel_rules_python//python:pip.bzl", "pip_repositories", "pip_import")
pip_repositories()
pip_import(
    name = "graknlabs_bazel_distribution_pip",
    requirements = "@graknlabs_bazel_distribution//pip:requirements.txt",
)
load("@graknlabs_bazel_distribution_pip//:requirements.bzl", graknlabs_bazel_distribution_pip_install = "pip_install")
graknlabs_bazel_distribution_pip_install()


###############
# Load @maven #
###############
maven(
    graknlabs_dependencies_artifacts,
)


#################################################
# Create @graknlabs_dependencies_workspace_refs #
#################################################
load("@graknlabs_bazel_distribution//common:rules.bzl", "workspace_refs")
workspace_refs(
    name = "graknlabs_dependencies_workspace_refs"
)
