#
# Copyright (C) 2021 Vaticle
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

package(default_visibility = ["//visibility:public"])

load("@vaticle_dependencies_ci_pip//:requirements.bzl", "requirement")
load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")


exports_files(["ValidateDeps.kt", "ValidateNodeJsDeps.kt", "ValidatePythonDeps.kt"])

py_binary(
    name = "docs",
    srcs = ["docs.py"],
    main = "docs.py"
)

py_binary(
    name = "create-notes",
    srcs = ["create-notes.py"],
    main = "create-notes.py",
    deps = [
        requirement("PyGithub"),
        requirement("urllib3"),
        requirement("chardet"),
        requirement("idna"),
        requirement("wrapt"),
        requirement("certifi"),
    ]
)

kt_jvm_binary(
    name = "bump",
    srcs = ["Bump.kt"],
    main_class = "tool.release.BumpKt",
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json",
        "@maven//:com_google_http_client_google_http_client",
    ],
)
