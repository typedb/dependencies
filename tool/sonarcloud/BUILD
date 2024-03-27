# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


package(default_visibility = ["//visibility:public"])

py_binary(
    name = "code-analysis",
    srcs = ["code-analysis.py"],
    main = "code-analysis.py",
    data = [ "@sonarscanner_zip//file"]
)
