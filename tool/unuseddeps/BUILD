package(default_visibility = ["//visibility:public"])

py_binary(
    name = "unused-deps",
    srcs = ["unused-deps.py"],
    data = [
        "@unused_deps_mac//file",
        "@unused_deps_linux//file",
        "@buildozer_mac//file",
        "@buildozer_linux//file",
    ]
)
