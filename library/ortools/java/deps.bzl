load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

version = "8.0.8283"

def google_or_tools_export_files(version, os):
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

def google_or_tools_import_files(workspace, artifact):
    return [
        workspace + "//:pom-runtime.xml",
        workspace + "//:ortools-" + artifact + "-" + version + ".jar",
        workspace + "//:ortools-" + artifact + "-" + version + "-sources.jar",
        workspace + "//:pom-local.xml",
        workspace + "//:ortools-java-" + version + ".jar",
        workspace + "//:ortools-java-" + version + "-sources.jar",
        workspace + "//:ortools-java-" + version + "-javadoc.jar",
    ]

def google_or_tools_mac():
    http_archive(
        name = "google_or_tools_darwin",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_MacOsX-10.15.7_v" + version + ".tar.gz"],
        strip_prefix = "or-tools_MacOsX-10.15.7_v" + version + "",
        build_file_content = google_or_tools_export_files(version, "darwin"),
        sha256 = "3c921c16c8162b337744dc45819dd5cf0c7a43382615edb8f599320bcf31773a"
    )

def google_or_tools_linux():
    http_archive(
        name = "google_or_tools_linux",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_debian-10_v" + version + ".tar.gz"],
        strip_prefix = "or-tools_Debian-10-64bit_v" + version + "",
        build_file_content = google_or_tools_export_files(version, "linux-x86-64"),
        sha256 = "7a15decbb983e4045b3d22dbfd82ccaaacfe1afbb2be9587bef64c9440e3cb99"
    )

def google_or_tools_windows():
    http_archive(
        name = "google_or_tools_windows",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_VisualStudio2019-64bit_v" + version + ".zip"],
        strip_prefix = "or-tools_VisualStudio2019-64bit_v" + version + "",
        build_file_content = google_or_tools_export_files(version, "win32-x86-64"),
        sha256 = "2d07658c6c1c5b9b93b13d0b2f47f5a58e0fb9230bdc9a9ec02d147befea2fb5"
    )
