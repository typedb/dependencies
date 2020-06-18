load("@graknlabs_build_tools_ci_pip//:requirements.bzl", "requirement")

py_binary(
    name = "release-docs",
    srcs = ["release-docs.py"],
    main = "release-docs.py"
)

py_binary(
    name = "release-approval",
    srcs = ["release-approval.py"],
    main = "release-approval.py",
    deps = [ "//:common"]
)

py_binary(
    name = "release-notes",
    srcs = ["release-notes.py"],
    main = "release-notes.py",
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
    name = "release-validate-deps",
    srcs = ["release-validate-deps.py"],
    main = "release-validate-deps.py",
)
