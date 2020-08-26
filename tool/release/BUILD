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

package(default_visibility = ["//visibility:public"])

load("@graknlabs_dependencies_ci_pip//:requirements.bzl", "requirement")

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
