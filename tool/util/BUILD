# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@io_bazel_rules_kotlin//kotlin:jvm.bzl", "kt_jvm_library")
load("//tool/checkstyle:rules.bzl", "checkstyle_test")

exports_files(["wait-for-host.sh"])

sh_binary(
    name = "restart-repo-container",
    srcs = ["restart-repo-container.sh"],
)

sh_binary(
    name = "ssh-repo-container",
    srcs = ["ssh-repo-container.sh"],
)

sh_binary(
    name = "ssh-repo-machine",
    srcs = ["ssh-repo-machine.sh"],
)

sh_binary(
    name = "install-ssh-credential",
    srcs = [":install-ssh-credential.sh"],
)

sh_binary(
    name = "wait-for-file",
    srcs = [":wait-for-file.sh"],
)

sh_binary(
    name = "transfer-file",
    srcs = [":transfer-file.sh"],
)

sh_binary(
    name = "create-systemd-service",
    srcs = [":create-systemd-service.sh"],
    data = [":systemd-service-template.txt"],
    args = ["$(location systemd-service-template.txt)"],
)

kt_jvm_library(
    name = "wait-for-host-lib",
    srcs = ["wait-for-host.kt"],
)

java_binary(
    name = "wait-for-host",
    runtime_deps = [":wait-for-host-lib"],
    main_class = "com.typedb.dependencies.tool.util.Wait_for_hostKt",
    visibility = ["//visibility:public"],
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "mpl-header",
    size = "small",
)
