load("@io_bazel_rules_kotlin//kotlin:jvm.bzl", "kt_jvm_binary")
load(":deps.bzl", "version", "google_or_tools_import_files")
load("//distribution:deployment.bzl", "deployment")

# fills the deployment url and OR-Tools version with 'sed'
genrule(
    name = "script",
    srcs = ["Deploy.template.kt"],
    outs = ["Deploy.kt"],
    cmd = "sed '{}; {}' $(SRCS) > $(OUTS)"
        .format(
            "s/{google_or_tools_version}/" + version + "/g",
            "s/{repository}/" + deployment['maven.release'].replace('/', '\\/') + "/g"
        )
)

kt_jvm_binary(
    name = "maven",
    main_class = "java",
    srcs = [":script"],
    deps = ["@maven//:org_zeroturnaround_zt_exec"],
    data = google_or_tools_import_files("@google_or_tools_darwin", "darwin") +
           google_or_tools_import_files("@google_or_tools_linux", "linux-x86-64") +
           google_or_tools_import_files("@google_or_tools_windows", "win32-x86-64")
)
