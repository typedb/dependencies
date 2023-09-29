load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def deps():
    http_file(
        name = "jdk17_linux_arm64",
        urls = ["https://download.oracle.com/java/17/latest/jdk-17_linux-aarch64_bin.tar.gz"],
        sha256 = "cd24d7b21ec0791c5a77dfe0d9d7836c5b1a8b4b75db7d33d253d07caa243117",
    )

    http_file(
        name = "jdk17_linux_x86_64",
        urls = ["https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz"],
        sha256 = "74b528a33bb2dfa02b4d74a0d66c9aff52e4f52924ce23a62d7f9eb1a6744657",
    )

    http_file(
        name = "jdk17_mac_arm64",
        urls = ["https://download.oracle.com/java/17/latest/jdk-17_macos-aarch64_bin.tar.gz"],
        sha256 = "89f26bda33262d70455e774b55678fc259ae4f29c0a99eb0377d570507be3d04",
    )

    http_file(
        name = "jdk17_mac_x86_64",
        urls = ["https://download.oracle.com/java/17/latest/jdk-17_macos-x64_bin.tar.gz"],
        sha256 = "ddc4928be11642f35b3cb1e6a56463032705fccb74e10ed5a67a73a5fc7b639f",
    )

    http_file(
        name = "jdk17_windows_x86_64",
        urls = ["https://download.oracle.com/java/17/latest/jdk-17_windows-x64_bin.zip"],
        sha256 = "98385c1fd4db7ad3fd7ca2f33a1fadae0b15486cfde699138d47002d7068084a",
    )

    http_file(
        name = "vaticle_apple_developer_id_application_cert",
        urls = ["https://repo.vaticle.com/repository/cert/apple/VaticleAppleDeveloperIDApplicationCertificate.p12"],
        sha256 = "4754e62a448f1c1dce7b377d5f1f26a5a28a6c43e6f31c05c7850ca4d0278f15",
        downloaded_file_path = "VaticleAppleDeveloperIDApplicationCertificate.p12",
    )

    http_file(
        name = "wix_toolset_311",
        urls = ["https://github.com/wixtoolset/wix3/releases/download/wix311rtm/wix311-binaries.zip"],
        sha256 = "da034c489bd1dd6d8e1623675bf5e899f32d74d6d8312f8dd125a084543193de",
    )
