load("@graknlabs_build_tools_ci_pip//:requirements.bzl", "requirement")

py_binary(
    name = "sync-dependencies",
    srcs = ["sync-dependencies.py"],
    main = "sync-dependencies.py",
    deps = [
        "//:common",
        requirement("PyGithub"),
        requirement("urllib3"),
        requirement("chardet"),
        requirement("idna"),
        requirement("wrapt"),
        requirement("certifi"),
    ],
)