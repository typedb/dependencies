# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

package(default_visibility = ["//visibility:public"])

load("@io_bazel_rules_kotlin//kotlin:jvm.bzl", "kt_jvm_binary")
load("//tool/checkstyle:rules.bzl", "checkstyle_test")

kt_jvm_binary(
    name = "dependency-analysis",
    srcs = ["DependencyAnalysis.kt"],
    main_class = "com.vaticle.dependencies.factory.analysis.DependencyAnalysisKt",
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json",
        "@maven//:org_zeroturnaround_zt_exec",
    ],
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "mpl-header",
    size = "small",
)
