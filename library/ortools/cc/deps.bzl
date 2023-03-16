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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

def google_or_tools():
    # Abseil-cpp
    git_repository(
        name = "com_google_absl",
        tag = "20211102.0",
        remote = "https://github.com/abseil/abseil-cpp.git",
    )

    # Protobuf
    git_repository(
        name = "com_google_protobuf",
        tag = "v3.19.4",
        remote = "https://github.com/protocolbuffers/protobuf.git",
    )

    # ZLIB
    new_git_repository(
        name = "zlib",
        build_file = "@com_google_protobuf//:third_party/zlib.BUILD",
        tag = "v1.2.11",
        remote = "https://github.com/madler/zlib.git",
    )

    git_repository(
        name = "com_google_re2",
        patches = ["@com_google_ortools//bazel:re2.patch"],
        tag = "2022-02-01",
        remote = "https://github.com/google/re2.git",
    )

    git_repository(
        name = "com_google_googletest",
        tag = "release-1.11.0",
        remote = "https://github.com/google/googletest.git",
    )

    http_archive(
        name = "glpk",
        build_file = "//bazel:glpk.BUILD",
        sha256 = "4a1013eebb50f728fc601bdd833b0b2870333c3b3e5a816eeba921d95bec6f15",
        url = "http://ftp.gnu.org/gnu/glpk/glpk-5.0.tar.gz",
    )

    http_archive(
        name = "bliss",
        build_file = "@com_google_ortools//bazel:bliss.BUILD",
        patches = ["@com_google_ortools//bazel:bliss-0.73.patch"],
        sha256 = "f57bf32804140cad58b1240b804e0dbd68f7e6bf67eba8e0c0fa3a62fd7f0f84",
        url = "http://www.tcs.hut.fi/Software/bliss/bliss-0.73.zip",
    )

    new_git_repository(
        name = "scip",
        build_file = "@com_google_ortools//bazel:scip.BUILD",
        patches = ["@com_google_ortools//bazel:scip.patch"],
        patch_args = ["-p1"],
        tag = "v800",
        remote = "https://github.com/scipopt/scip.git",
    )

    # Eigen has no Bazel build.
    new_git_repository(
        name = "eigen",
        tag = "3.4.0",
        remote = "https://gitlab.com/libeigen/eigen.git",
        build_file_content =
"""
cc_library(
name = 'eigen3',
srcs = [],
includes = ['.'],
hdrs = glob(['Eigen/**']),
visibility = ['//visibility:public'],
)
"""
    )

    git_repository(
        name = "com_google_ortools",
        remote = "https://github.com/google/or-tools.git",
        tag = "v9.3",
    )