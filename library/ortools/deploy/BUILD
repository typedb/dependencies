load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")
load(":deps.bzl", "version", "archive_import")
load("//distribution:deployment.bzl", "deployment")

# fills the deployment url and OR-Tools version with 'sed'
genrule(
    name = "script",
    srcs = ["Deploy.template.kt"],
    outs = ["Deploy.kt"],
    cmd = "sed '{}; {}' $(SRCS) > $(OUTS)"
        .format(
            "s/{google_or_tools_version}/" + version + "/g",
            "s/{repository}/" + deployment['maven.release'].replace('/', '\/') + "/g"
        )
)

kt_jvm_binary(
    name = "maven",
    main_class = "library.ortools.deploy.DeployKt",
    srcs = [":script"],
    deps = ["@maven//:org_zeroturnaround_zt_exec"],
    data = archive_import("darwin", "darwin") + archive_import("linux", "linux-x86-64") + archive_import("windows", "win32-x86-64")
)
