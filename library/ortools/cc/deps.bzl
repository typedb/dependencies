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

#def build_file_content(lib):
#    return """
#cc_import(
#   name = "lib",
#   shared_library = "lib/{0}",
#   visibility = ["//visibility:public"]
#)
#cc_library(
#  name = "incl",
#  hdrs = glob([
#      "include/ortools/**/*.h",
#      "include/absl/**/*.h",
#      "include/absl/**/*.inc",
#      "include/google/protobuf/**/*.inc",
#      "include/google/protobuf/**/*.h",
#  ]),
#  strip_include_prefix = "include/",
#  visibility = ["//visibility:public"]
#)
#""".format(lib)

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
        #tag = "v9.3",
        commit = "525162feaadaeef640783b2eaea38cf4b623877f",
        shallow_since = "1647023481 +0100",
    )
#
#def google_or_tools_linux():
#    http_archive(
#        name = "or_tools_linux",
#        urls = ["https://github.com/google/or-tools/releases/download/v9.0/or-tools_debian-10_v9.0.9048.tar.gz"],
#        strip_prefix = "or-tools_Debian-10-64bit_v9.0.9048/",
#        sha256 = "063fb1d8765ae23b0bb25b9c561e904532713416fe0458f7db45a0f72190eb50",
#        build_file_content = build_file_content("libortools.so")
#    )
#
#def google_or_tools_mac():
#    http_archive(
#        name = "or_tools_mac",
#        urls = ["https://github.com/google/or-tools/releases/download/v9.0/or-tools_MacOsX-11.2.3_v9.0.9048.tar.gz"],
#        strip_prefix = "or-tools_MacOsX-11.2.3_v9.0.9048/",
#        sha256 = "adf73a00d4ec49558b67be5ce3cfc8f30268da2253b35feb11d0d40700550bf6",
#        build_file_content = build_file_content("libortools.dylib")
#    )
#
#def google_or_tools_windows():
#    http_archive(
#        name = "or_tools_windows",
#        urls = ["https://github.com/google/or-tools/releases/download/v9.0/or-tools_VisualStudio2019-64bit_v9.0.9048.zip"],
#        strip_prefix = "or-tools_VisualStudio2019-64bit_v9.0.9048/",
#        sha256 = "1be7286e082ba346f8729a873c5fd85418ac2dc95b847d9baa5381c5ac5f5fd9",
#        build_file_content = build_file_content("ortools.lib")
#    )
