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

sh_binary(
    name = "sync",
    srcs = ["sync.sh"],
    visibility = ["//visibility:public"]
)

java_binary(
    name = "generate_cargo_manifests",
    runtime_deps = [
        ":cargo_manifest_generator"
    ],
    main_class = "com.vaticle.dependencies.ide.rust.CargoManifestGeneratorKt",
)

kt_jvm_library(
    name = "cargo_manifest_generator",
    deps = [
        "@vaticle_bazel_distribution//common/util",

        "@maven//:com_electronwill_night_config_core",
        "@maven//:com_electronwill_night_config_toml",
        "@maven//:info_picocli_picocli",
    ],
    srcs = [
        "CargoManifestGenerator.kt"
    ]
)
