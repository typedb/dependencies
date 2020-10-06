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

package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")
load("@graknlabs_bazel_distribution//maven:rules.bzl", "assemble_maven", "deploy_maven")
load("@graknlabs_dependencies//distribution:deployment.bzl", "deployment")

kt_jvm_binary(
    name = "build-script",
    main_class = "library.rocksdbjni.RocksDbBuilderKt",
    srcs = ["RocksDbBuilder.kt"],
    deps = [
        # Maven dependencies
        "@maven//:org_zeroturnaround_zt_exec"
    ],
)

genrule(
    name = "builder",
    outs = [
        "rocksdbjni-osx.jar",
        "rocksdbjni-sources.jar",
    ],
    srcs = ["VERSION"],
    cmd = "$(execpath :build-script) && read -a outs <<< '$(OUTS)' && mv rocksdbjni-osx.jar $${outs[0]} && mv rocksdbjni-sources.jar $${outs[1]}",
    tools = ["@bazel_tools//tools/jdk:current_host_java_runtime", ":build-script"],
)

java_import(
    name = "java-lib",
    jars = ["rocksdbjni-osx.jar"],
    srcjar = "rocksdbjni-sources.jar",
    tags = ["no-ide", "maven_coordinates=org.rocksdb:rocksdbjni-dev:{pom_version}"],
)

assemble_maven(
    name = "assemble-maven",
    target = ":java-lib",
    version_file = "VERSION",
)

deploy_maven(
    name = "deploy-maven",
    target = ":assemble-maven",
    snapshot = deployment["maven.snapshot"],
    release = deployment["maven.release"],
)
