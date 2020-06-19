load("@graknlabs_dependencies_ci_pip//:requirements.bzl", "requirement")

py_binary(
    name = "dependencies",
    srcs = ["dependencies.py"],
    main = "dependencies.py",
    deps = [
        "//tools:common",
        requirement("PyGithub"),
        requirement("urllib3"),
        requirement("chardet"),
        requirement("idna"),
        requirement("wrapt"),
        requirement("certifi"),
    ],
)