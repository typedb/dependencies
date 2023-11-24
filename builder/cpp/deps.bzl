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
        urls = ["https://github.com/krishnangovindraj/gherkin/archive/refs/heads/main.zip"],
        strip_prefix = "gherkin-main/cpp",
        sha256 = "29e098c87c97cdd43b1449af2d9cb05e9b76359e4d8028647671fff7fffb85e2",
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
        urls = ["https://github.com/krishnangovindraj/cucumber-messages/archive/refs/heads/main.zip"],
        strip_prefix = "cucumber-messages-main/cpp",
        sha256 = "369de231fdb01ee7a06cb75779dd4b2aa15f95bbf58c11286e2ea596a840f4b3",
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
