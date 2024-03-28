# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("//tool/checkstyle:rules.bzl", "checkstyle_test")

filegroup(
    name = "license_files",
    srcs = [
        "checkstyle-file-mpl-header.txt",
        "checkstyle-file-apache-header.txt",
        "checkstyle-file-commercial-header.txt",
        "checkstyle-file-mpl-fulltext.txt",
        "checkstyle-file-apache-fulltext.txt",
        "checkstyle-file-commercial-fulltext.txt",
    ],
    visibility = ["//visibility:public"]
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    exclude = glob(["*.txt"]),
    license_type = "mpl-header",
    size = "small",
)
