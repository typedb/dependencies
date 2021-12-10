load("@bazel_skylib//rules:run_binary.bzl", "run_binary")
load("@rules_cc//cc:defs.bzl", "cc_library")

def rust_cxx_bridge(name, src, deps = []):
    run_binary(
        name = "%s_generator" % name,
        srcs = [src],
        outs = [
            src + ".h",
            src + ".cc",
        ],
        args = [
            "$(location %s)" % src,
            "-o",
            "$(location %s.h)" % src,
            "-o",
            "$(location %s.cc)" % src,
        ],
        tool = select({
            "@vaticle_dependencies//util/platform:is_mac": "@cxxbridge_mac//file",
            "@vaticle_dependencies//util/platform:is_linux": "@cxxbridge_linux//file",
            "@vaticle_dependencies//util/platform:is_windows": "@cxxbridge_windows//file",
#            "//conditions:default": [name + "-mac"],
        }),
    )

    cc_library(
        name = "%s_include" % name,
        hdrs = [src + ".h"],
    )

    cc_library(
        name = name,
        srcs = [src + ".cc"],
        deps = deps + [":%s_include" % name],
    )
