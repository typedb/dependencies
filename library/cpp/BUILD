# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("//tool/checkstyle:rules.bzl", "checkstyle_test")

exports_files(["clang_format.sh", ".clang-format"])

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    exclude = [
        ".clang-format"
    ],
    license_type = "mpl-header",
    size = "small",
)
