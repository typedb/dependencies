# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("//tool/checkstyle:rules.bzl", "checkstyle_test")

package(default_visibility = ["//visibility:public"])

py_binary(
    name = "unused-deps",
    srcs = ["unused-deps.py"],
    data = [
        "@unused_deps_mac//file",
        "@unused_deps_linux//file",
        "@buildozer_mac//file",
        "@buildozer_linux//file",
    ]
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "mpl-header",
    size = "small",
)
