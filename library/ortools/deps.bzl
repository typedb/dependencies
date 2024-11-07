# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


google_or_tools = select({
         "@typedb_bazel_distribution//platform:is_mac": [
             "@maven//:com_google_ortools_ortools_darwin",
             "@maven//:com_google_ortools_ortools_darwin_java",
         ],
         "@typedb_bazel_distribution//platform:is_linux": [
             "@maven//:com_google_ortools_ortools_linux_x86_64",
             "@maven//:com_google_ortools_ortools_linux_x86_64_java"
         ],
         "@typedb_bazel_distribution//platform:is_windows": [
             "@maven//:com_google_ortools_ortools_win32_x86_64",
             "@maven//:com_google_ortools_ortools_win32_x86_64_java"
         ],
         "//conditions:default": [
             "@maven//:com_google_ortools_ortools_darwin",
             "@maven//:com_google_ortools_ortools_darwin_java",
         ],
     })
