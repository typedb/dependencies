load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

version = "8.0.8283"

def archive_export(version, os):
    return """
exports_files([
   "pom-runtime.xml",
   "ortools-{1}-{0}.jar",
   "ortools-{1}-{0}-sources.jar",

   "pom-local.xml",
   "ortools-java-{0}.jar",
   "ortools-java-{0}-sources.jar",
   "ortools-java-{0}-javadoc.jar"
])
""".format(version, os)

def archive_import(os, artifact):
    return [
        "@google_or_tools_" + os + "//:pom-runtime.xml",
        "@google_or_tools_" + os + "//:ortools-" + artifact + "-" + version + ".jar",
        "@google_or_tools_" + os + "//:ortools-" + artifact + "-" + version + "-sources.jar",
        "@google_or_tools_" + os + "//:pom-local.xml",
        "@google_or_tools_" + os + "//:ortools-java-" + version + ".jar",
        "@google_or_tools_" + os + "//:ortools-java-" + version + "-sources.jar",
        "@google_or_tools_" + os + "//:ortools-java-" + version + "-javadoc.jar",
    ]

def google_or_tools_darwin():
    http_archive(
        name = "google_or_tools_darwin",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_MacOsX-10.15.7_v" + version + ".tar.gz"],
        strip_prefix = "or-tools_MacOsX-10.15.7_v" + version + "",
        build_file_content = archive_export(version, "darwin")
    )

def google_or_tools_linux():
    http_archive(
        name = "google_or_tools_linux",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_debian-10_v" + version + ".tar.gz"],
        strip_prefix = "or-tools_Debian-10-64bit_v" + version + "",
        build_file_content = archive_export(version, "linux-x86-64")
    )

def google_or_tools_windows():
    http_archive(
        name = "google_or_tools_windows",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_VisualStudio2019-64bit_v" + version + ".zip"],
        strip_prefix = "or-tools_VisualStudio2019-64bit_v" + version + "",
        build_file_content = archive_export(version, "win32-x86-64")
    )
