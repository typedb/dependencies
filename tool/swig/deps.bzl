# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


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
