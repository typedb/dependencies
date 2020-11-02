load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

version = "8.0.8283"

def google_or_tools_darwin():
    http_archive(
        name = "google_ortools_darwin",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_MacOsX-10.15.7_v" + version + ".tar.gz"],
        strip_prefix = "or-tools_MacOsX-10.15.7_v" + version + "",
        build_file_content = """
            exports_files([
              "pom-runtime.xml",
              "ortools-darwin-{0}.jar",
              "ortools-darwin-{0}-sources.jar",

              "pom-local.xml",
              "ortools-java-{0}.jar",
              "ortools-java-{0}-sources.jar",
              "ortools-java-{0}-javadoc.jar",
            ])
        """.format(version)
    )

def google_or_tools_linux():
    http_archive(
        name = "google_ortools_linux",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_debian-10_v" + version + ".tar.gz"],
        strip_prefix = "or-tools_Debian-10-64bit_v" + version + "",
        build_file_content = """
            exports_files([
                "ortools-linux-x86-64-{0}-sources.jar",
                "ortools-linux-x86-64-{0}.jar",
                "pom-runtime.xml",
            ])
        """.format(version)
    )

def google_or_tools_windows():
    http_archive(
        name = "google_ortools_windows",
        urls = ["https://github.com/google/or-tools/releases/download/v8.0/or-tools_VisualStudio2019-64bit_v" + version + ".zip"],
        strip_prefix = "or-tools_VisualStudio2019-64bit_v" + version + "",
        build_file_content = """
            exports_files([
                "ortools-win32-x86-64-{0}-sources.jar",
                "ortools-win32-x86-64-{0}.jar",
                "pom-runtime.xml",
            ])
        """.format(version)
    )
