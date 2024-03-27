# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@io_bazel_rules_kotlin//kotlin:jvm.bzl", "kt_jvm_binary")

package(default_visibility = ["//visibility:public"])

kt_jvm_binary(
    name = "validate",
    srcs = glob(["NotesValidate.kt", "Commit.kt", "Common.kt", "Version.kt"]),
    main_class = "com.vaticle.dependencies.tool.release.notes.NotesValidateKt",
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json",
        "@maven//:com_google_http_client_google_http_client",
        "@maven//:org_zeroturnaround_zt_exec",
    ],
)

kt_jvm_binary(
    name = "create",
    srcs = glob(["NotesCreate.kt", "Note.kt", "Commit.kt", "Common.kt", "Version.kt"]),
    main_class = "com.vaticle.dependencies.tool.release.notes.NotesCreateKt",
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json",
        "@maven//:com_google_http_client_google_http_client",
        "@maven//:org_zeroturnaround_zt_exec",
    ],
)
