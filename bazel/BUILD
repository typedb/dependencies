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

load("@bazel_tools//tools/jdk:default_java_toolchain.bzl", "default_java_toolchain")


java_binary(
    name = "bazel-deps",
    main_class = "com.github.johnynek.bazel_deps.ParseProject",
    visibility = ["//visibility:public"],
    runtime_deps = ["@bazel_deps//jar:jar"],
)

sh_binary(
    name = "unused-deps",
    srcs = ["unused-deps.sh"],
    data = [
        "@unused_deps//file",
        "@unused_deps_osx//file",
    ],
)

# Toolchain that redefines singlejar to a version
# that produces IntelliJ-compatible source JARs
default_java_toolchain(
    name = "java-toolchain",
    source_version = "8",
    target_version = "8",
    singlejar = [":singlejar_deploy.jar"],
    visibility = ["//visibility:public"],
)

# Wrapper that remaps .java files to have correct
# placement inside the source JAR
java_binary(
    name = "singlejar",
    srcs = ["SingleJar.java"],
    resources = [
        "@bazel_tools//tools/jdk:singlejar"
    ],
    main_class = "grakn.buildtools.SingleJar"
)
