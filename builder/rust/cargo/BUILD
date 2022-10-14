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

kt_jvm_library(
    name = "project_structure_builder",
    deps = [
        "@vaticle_bazel_distribution//common/util",

        "@maven//:com_electronwill_night_config_core",
        "@maven//:com_electronwill_night_config_toml",
        "@maven//:info_picocli_picocli",
    ],
    srcs = [
        "ProjectStructureBuilder.kt"
    ]
)

java_binary(
    name = "build_project_structure",
    runtime_deps = [
        ":project_structure_builder"
    ],
    main_class = "com.vaticle.dependencies.builder.rust.cargo.ProjectStructureBuilderKt",
)

sh_binary(
    name = "generate_project",
    srcs = ["generate-project.sh"],
    visibility = ["//visibility:public"]
)
