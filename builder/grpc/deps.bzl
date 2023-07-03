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
        name = "bazelruby_rules_ruby",
        remote = "https://github.com/bazelruby/rules_ruby.git",
        branch = "master"
    )


    git_repository(
        name = "com_github_grpc_grpc",
        remote = "https://github.com/grpc/grpc",
        tag = "v1.56.0"
    )
    git_repository(
        name = "io_grpc_grpc_java",
        remote = "https://github.com/grpc/grpc-java",
        tag = "v1.56.1"
    )
    http_archive(
        name = "build_stack_rules_proto",
        sha256 = "ac7e2966a78660e83e1ba84a06db6eda9a7659a841b6a7fd93028cd8757afbfb",
        strip_prefix = "rules_proto-2.0.1",
        urls = ["https://github.com/stackb/rules_proto/archive/v2.0.1.tar.gz"],
    )
