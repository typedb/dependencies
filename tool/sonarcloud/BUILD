# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("//tool/checkstyle:rules.bzl", "checkstyle_test")

package(default_visibility = ["//visibility:public"])

py_binary(
    name = "code-analysis",
    srcs = ["code-analysis.py"],
    main = "code-analysis.py",
    data = select({
        "@vaticle_bazel_distribution//platform:is_linux" : [ "@sonarscanner_linux_zip//file" ],
        "@vaticle_bazel_distribution//platform:is_mac" : [ "@sonarscanner_mac_zip//file" ],
        "//conditions:default" : [ "@sonarscanner_zip//file" ]
    })
)

checkstyle_test(
    name = "checkstyle",
    include = glob(["*"]),
    license_type = "mpl-header",
    size = "small",
)
