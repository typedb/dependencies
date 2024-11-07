# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps():
    http_archive(
        name = "gtest",
        sha256 = "24564e3b712d3eb30ac9a85d92f7d720f60cc0173730ac166f27dda7fed76cb2",
        strip_prefix = "googletest-release-1.12.1",
        urls = ["https://github.com/google/googletest/archive/refs/tags/release-1.12.1.zip"],
    )

    http_archive(
        name = "gherkin_cpp",
        urls = ["https://github.com/typedb/gherkin/archive/19b7ca13da8bb4cb6dc27ef5af572a8a1233deb8.zip"],
        strip_prefix = "gherkin-19b7ca13da8bb4cb6dc27ef5af572a8a1233deb8/cpp",
        sha256 = "f8fd8d46b384a3c27a3bfed0e5eb1ad4ae2dbac862b18153a76178ec35a2c459",
        build_file_content = """
cc_library(
  name = "gherkin-lib",
  deps = ["@nlohmann_json//:json", "@cucumber_messages//:cucumber-messages-lib"],
  hdrs = glob(["include/**/*.hpp"]),
  strip_include_prefix = "include",
  srcs = glob(["src/lib/gherkin/**/*.cpp"]),
  copts = ["--std=c++17"],
  visibility= ["//visibility:public"],
)
        """
    )

    http_archive(
        name = "cucumber_messages",
        urls = ["https://github.com/typedb/cucumber-messages/archive/fc5c391add237b0d5fa090072757a500863c24b7.zip"],
        strip_prefix = "cucumber-messages-fc5c391add237b0d5fa090072757a500863c24b7/cpp",
        sha256 = "048a04c8b1163f601dc8992d41f3254a5ce58ac487514ee4ddd06090aa666d25",
        build_file_content = """
cc_library(
  name = "cucumber-messages-lib",
  deps = ["@nlohmann_json//:json"],
  hdrs = glob(["include/**/*.hpp"]),
  strip_include_prefix = "include",
  srcs = glob(["src/lib/cucumber-messages/**/*.cpp", "src/lib/cucumber-messages/**/*.hpp"]),
  copts = [
    "--std=c++17",
     "-isystem external/cucumber_messages/src/lib/cucumber-messages",
  ],
  visibility= ["@gherkin_cpp//:__pkg__", "//cpp/test:__subpackages__"],
)
    """
    )

    http_archive(
        name = "nlohmann_json",
        urls = ["https://github.com/nlohmann/json/archive/refs/tags/v3.11.2.zip"],
        strip_prefix = "json-3.11.2",
        sha256 = "95651d7d1fcf2e5c3163c3d37df6d6b3e9e5027299e6bd050d157322ceda9ac9",
        build_file_content = """
cc_library(
  name = "json",
  hdrs = ["single_include/nlohmann/json.hpp"],
  srcs = [],
  includes = ["single_include"],
  copts = ["--std=c++17"],
  visibility= ["//visibility:public"],
)
    """
    )
