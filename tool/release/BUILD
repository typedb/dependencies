load("@graknlabs_dependencies_ci_pip//:requirements.bzl", "requirement")
load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")

exports_files(["ValidateDeps.kt"])

py_binary(
    name = "docs",
    srcs = ["docs.py"],
    main = "docs.py"
)

py_binary(
    name = "approval",
    srcs = ["approval.py"],
    main = "approval.py",
    deps = [ "//tool/common:common" ]
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

kt_jvm_binary(
    name = "validate-deps-refs",
    main_class = "tool.release.Validate_depsKt",
    srcs = ["ValidateDeps.kt"],
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json"
    ]
)