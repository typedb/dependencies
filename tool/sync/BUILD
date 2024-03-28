# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("@vaticle_dependencies_ci_pip//:requirements.bzl", "requirement")
load("//tool/checkstyle:rules.bzl", "checkstyle_test")

package(default_visibility = ["//visibility:public"])

py_binary(
    name = "dependencies",
    srcs = ["dependencies.py"],
    main = "dependencies.py",
    deps = [
        "//tool/common:common",
        requirement("PyGithub"),
        requirement("urllib3"),
        requirement("chardet"),
        requirement("idna"),
        requirement("wrapt"),
        requirement("certifi"),
    ],
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "mpl-header",
    size = "small",
)
