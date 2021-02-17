#
# Copyright (C) 2021 Grakn Labs
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

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary", "kt_jvm_library")
load("@graknlabs_bazel_distribution//maven:rules.bzl", "assemble_maven", "deploy_maven")
load("@graknlabs_dependencies//distribution:deployment.bzl", "deployment")

kt_jvm_library(
    name = "common",
    srcs = ["Common.kt"],
    deps = ["@maven//:org_zeroturnaround_zt_exec" ]
)

kt_jvm_binary(
    name = "builder-mac",
    main_class = "library.rocksdbjni.mac.BuilderMacKt",
    srcs = ["BuilderMac.kt"],
    deps = [
        ":common",
        "@maven//:org_zeroturnaround_zt_exec"
    ],
)

genrule(
    name = "compile-mac",
    outs = [
        "rocksdbjni-osx.jar",
        "rocksdbjni-sources.jar",
    ],
    srcs = ["VERSION"],
    cmd = "$(execpath :builder-mac) && read -a outs <<< '$(OUTS)' && mv rocksdbjni-osx.jar $${outs[0]} && mv rocksdbjni-sources.jar $${outs[1]}",
    tools = ["@bazel_tools//tools/jdk:current_host_java_runtime", ":builder-mac"],
    tags = ["manual"]
)

java_import(
    name = "rocksdbjni-dev-mac",
    jars = ["rocksdbjni-osx.jar"],
    srcjar = "rocksdbjni-sources.jar",
    tags = ["manual", "no-ide", "maven_coordinates=org.rocksdb:rocksdbjni-dev-mac:{pom_version}"],
)

assemble_maven(
    name = "assemble-maven-mac",
    target = ":rocksdbjni-dev-mac",
    version_file = "VERSION",
    tags = ["manual"]
)

deploy_maven(
    name = "deploy-maven-mac",
    target = ":assemble-maven-mac",
    snapshot = deployment["maven.snapshot"],
    release = deployment["maven.release"],
    tags = ["manual"]
)

kt_jvm_binary(
    name = "builder-linux",
    main_class = "library.rocksdbjni.linux.BuilderLinuxKt",
    srcs = ["BuilderLinux.kt"],
    deps = [
        ":common",
        "@maven//:org_zeroturnaround_zt_exec"
    ],
)

genrule(
    name = "compile-linux",
    outs = [
        "rocksdbjni-linux.jar",
#        "rocksdbjni-sources.jar", // TODO: enable once we found a way to generate source jar under Linux
    ],
    srcs = ["VERSION"],
    cmd = "$(execpath :builder-linux) && read -a outs <<< '$(OUTS)' && mv rocksdbjni-linux.jar $${outs[0]}",
    tools = ["@bazel_tools//tools/jdk:current_host_java_runtime", ":builder-linux"],
    tags = ["manual"]
)

java_import(
    name = "rocksdbjni-dev-linux",
    jars = [
        "rocksdbjni-linux.jar"
#        "rocksdbjni-sources.jar", // TODO: enable once we found a way to generate source jar under Linux
    ],
    tags = ["manual", "no-ide", "maven_coordinates=org.rocksdb:rocksdbjni-dev-linux:{pom_version}"],
)

assemble_maven(
    name = "assemble-maven-linux",
    target = ":rocksdbjni-dev-linux",
    version_file = "VERSION",
    tags = ["manual"]
)

#deploy_maven(
#    name = "deploy-maven-linux",
#    target = ":assemble-maven-linux",
#    snapshot = deployment["maven.snapshot"],
#    release = deployment["maven.release"],
#    tags = ["manual"]
#)
