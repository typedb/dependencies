#
# Copyright (C) 2022 Vaticle
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

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps():
    git_repository(
       name = "rules_proto_grpc",
       remote = "https://github.com/rules-proto-grpc/rules_proto_grpc",
       commit = "7064b28a75b3feb014b20d3276e17498987a68e2"
    )
    http_archive(
        name = "com_github_grpc_grpc",
        sha256 = "79e3ff93f7fa3c8433e2165f2550fa14889fce147c15d9828531cbfc7ad11e01",
        strip_prefix = "grpc-1.54.1",
        urls = ["https://github.com/grpc/grpc/archive/v1.54.1.tar.gz"],
    )
