#
# Copyright (C) 2020 Grakn Labs
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


load("@graknlabs_dependencies_ci_pip//:requirements.bzl", "requirement")
load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")

exports_files(["ValidateDeps.kt"])

py_binary(
    name = "docs",
    srcs = ["docs.py"],
    main = "docs.py"
)

py_binary(
    name = "approval",
    srcs = ["approval.py"],
    main = "approval.py",
    deps = [ "//tool/common:common" ]
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

# this is here to allow compiling and easier development of `ValidateDeps.kt`, otherwise not recognised as a target
# (is actually just a string template)
kt_jvm_binary(
    name = "validate-deps-refs",
    main_class = "tool.release.Validate_depsKt",
    srcs = ["ValidateDeps.kt"],
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json"
    ]
)
