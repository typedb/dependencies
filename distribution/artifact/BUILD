# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("//tool/checkstyle:rules.bzl", "checkstyle_test")

sh_binary(
    name = "create-netrc",
    srcs = ["create-netrc.sh"],
    visibility = ["//visibility:public"],
)

sh_binary(
    name = "artifact-repackage",
    srcs = ["artifact-repackage.sh"],
    visibility = ["//visibility:public"],
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "mpl-header",
    size = "small",
)
