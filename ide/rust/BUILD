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

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_library")

java_binary(
    name = "sync",
    runtime_deps = [
        ":sync_lib",
    ],
    main_class = "com.vaticle.dependencies.ide.rust.SyncRunnerKt",
)

kt_jvm_library(
    name = "sync_lib",
    srcs = [
        "IDESyncInfo.kt",
        "SyncRunner.kt",
    ],
    deps = [
        "@vaticle_dependencies//ide/rust:cargo_manifest_generator",

        "@vaticle_bazel_distribution//common",
        "@vaticle_bazel_distribution//common/shell",
        "@vaticle_bazel_distribution//common/util",

        "@maven//:info_picocli_picocli",
        "@maven//:org_zeroturnaround_zt_exec",
    ]
)

kt_jvm_library(
    name = "cargo_manifest_generator",
    deps = [
        "@vaticle_bazel_distribution//common/shell",
        "@vaticle_bazel_distribution//common/util",

        "@maven//:com_electronwill_night_config_core",
        "@maven//:com_electronwill_night_config_toml",
        "@maven//:org_zeroturnaround_zt_exec",
    ],
    srcs = [
        "CargoManifestGenerator.kt"
    ]
)
