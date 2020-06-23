load("@graknlabs_dependencies_ci_pip//:requirements.bzl", "requirement")

py_binary(
    name = "docs",
    srcs = ["docs.py"],
    main = "docs.py"
)

py_binary(
    name = "approval",
    srcs = ["approval.py"],
    main = "approval.py",
    deps = [ "//tool:common" ]
)

py_binary(
    name = "create-notes",
    srcs = ["create-notes.py"],
    main = "create-notes.py",
    deps = [
        requirement("PyGithub"),
        requirement("urllib3"),
        requirement("chardet"),
        requirement("idna"),
        requirement("wrapt"),
        requirement("certifi"),
    ]
)

py_binary(
    name = "validate-deps",
    srcs = ["validate-deps.py"],
    main = "validate-deps.py",
)
