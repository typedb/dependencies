#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2018 Grakn Labs Ltd
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

exports_files(["requirements.txt"])
load("@graknlabs_build_tools_ci_pip//:requirements.bzl", "requirement")

py_binary(
    name = "sync-dependencies",
    srcs = ["sync-dependencies.py"],
    main = "sync-dependencies.py",
    deps = [
        requirement("PyGithub"),
        requirement("urllib3"),
        requirement("chardet"),
        requirement("idna"),
        requirement("wrapt"),
        requirement("certifi"),
    ],
)

py_binary(
    name = "release-docs",
    srcs = ["release-docs.py"],
    main = "release-docs.py"
)

py_binary(
    name = "release-approval",
    srcs = ["release-approval.py"],
    main = "release-approval.py"
)

sh_binary(
    name = "install-bazel-rbe",
    srcs = ["install-bazel-rbe.sh"]
)

py_binary(
    name = "run-bazel-rbe",
    srcs = ["run-bazel-rbe.py"],
    main = "run-bazel-rbe.py"
)

py_binary(
    name = "test-cache",
    srcs = ["test-cache.py"],
    main = "test-cache.py"
)
