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

def build_file_content(lib):
    return """
cc_import(
   name = "lib",
   shared_library = "lib/{0}",
   visibility = ["//visibility:public"]
)
cc_library(
  name = "incl",
  hdrs = glob([
      "include/ortools/**/*.h",
      "include/absl/**/*.h",
      "include/absl/**/*.inc",
      "include/google/protobuf/**/*.inc",
      "include/google/protobuf/**/*.h",
  ]),
  strip_include_prefix = "include/",
  visibility = ["//visibility:public"]
)
""".format(lib)

def google_or_tools_linux():
    http_archive(
        name = "or_tools_linux",
        urls = ["https://github.com/google/or-tools/releases/download/v9.0/or-tools_debian-10_v9.0.9048.tar.gz"],
        strip_prefix = "or-tools_Debian-10-64bit_v9.0.9048/",
        sha256 = "063fb1d8765ae23b0bb25b9c561e904532713416fe0458f7db45a0f72190eb50",
        build_file_content = build_file_content("libortools.so")
    )

def google_or_tools_mac():
    http_archive(
        name = "or_tools_mac",
        urls = ["https://github.com/google/or-tools/releases/download/v9.0/or-tools_MacOsX-11.2.3_v9.0.9048.tar.gz"],
        strip_prefix = "or-tools_MacOsX-11.2.3_v9.0.9048/",
        sha256 = "adf73a00d4ec49558b67be5ce3cfc8f30268da2253b35feb11d0d40700550bf6",
        build_file_content = build_file_content("libortools.dylib")
    )

def google_or_tools_windows():
    http_archive(
        name = "or_tools_windows",
        urls = ["https://github.com/google/or-tools/releases/download/v9.0/or-tools_VisualStudio2019-64bit_v9.0.9048.zip"],
        strip_prefix = "or-tools_VisualStudio2019-64bit_v9.0.9048/",
        sha256 = "1be7286e082ba346f8729a873c5fd85418ac2dc95b847d9baa5381c5ac5f5fd9",
        build_file_content = build_file_content("ortools.lib")
    )
