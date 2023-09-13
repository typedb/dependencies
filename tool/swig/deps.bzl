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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def deps():
    http_archive(
        name = "swig",
        urls = ["http://prdownloads.sourceforge.net/swig/swig-4.1.1.tar.gz"],
        strip_prefix = "swig-4.1.1",
        sha256 = "2af08aced8fcd65cdb5cc62426768914bedc735b1c250325203716f78e39ac9b",
        build_file_content = """
filegroup(
    name = "templates",
    srcs = glob(["Lib/**/*.i", "Lib/**/*.swg"]),
    path = "Lib",
)

genrule(
    name = "swigconfig",
    outs = ["Source/Include/swigconfig.h"],
    cmd = \"""cat >$@ <<EOF
#define PACKAGE_BUGREPORT "http://www.swig.org"
#define PACKAGE_VERSION "4.1.1"
#define SWIG_CXX "unknown"
#define SWIG_LIB "external/swig/Lib"
#define SWIG_LIB_WIN_UNIX SWIG_LIB
#define SWIG_PLATFORM "unknown"
EOF
    \""",
)

cc_binary(
    name = "swig",
    srcs = [":swigconfig"] + glob([
        "Source/**/*.h",
        "Source/**/*.c",
        "Source/**/*.cc",
        "Source/**/*.cxx",
    ]),
    copts = [
        "-Iexternal/swig/Source/CParse",
        "-Iexternal/swig/Source/DOH",
        "-Iexternal/swig/Source/Doxygen",
        "-Iexternal/swig/Source/Include",
        "-Iexternal/swig/Source/Modules",
        "-Iexternal/swig/Source/Preprocessor",
        "-Iexternal/swig/Source/Swig",
        "-fexceptions",
    ],
    data = [":templates"],
    includes = ["Source/Include"],
    visibility = ["//visibility:public"]
)
        """
    )
