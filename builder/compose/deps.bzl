load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def deps():
    http_file(
        name = "org_jetbrains_compose_compiler",
        urls = ["https://maven.pkg.jetbrains.space/public/p/compose/dev/org/jetbrains/compose/compiler/compiler-hosted/1.0.0-rc3/compiler-hosted-1.0.0-rc3.jar"],
        sha256 = "1e628a81ad501bc737ca4ea193b8c5072a4baa022b3152aacb928bf076af8226",
        downloaded_file_path = "compiler-hosted-1.0.0-rc3.jar",
    )

    http_file(
        name = "jdk16_mac",
        urls = ["https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_osx-x64_bin.tar.gz"],
        sha256 = "e65f2437585f16a01fa8e10139d0d855e8a74396a1dfb0163294ed17edd704b8",
    )

    http_file(
        name = "jdk16_windows",
        urls = ["https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_windows-x64_bin.zip"],
        sha256 = "9df98be05fe674066cc39144467c47b1503cfa3de059c09cc4ccc3da9c253b9a",
    )

    http_file(
        name = "jdk16_linux",
        urls = ["https://download.java.net/java/GA/jdk16.0.2/d4a915d82b4c4fbb9bde534da945d746/7/GPL/openjdk-16.0.2_linux-x64_bin.tar.gz"],
        sha256 = "6c714ded7d881ca54970ec949e283f43d673a142fda1de79b646ddd619da9c0c",
    )

    http_file(
        name = "jdk17_linux",
        urls = ["https://download.java.net/java/GA/jdk17/0d483333a00540d886896bac774ff48b/35/GPL/openjdk-17_linux-x64_bin.tar.gz"],
        sha256 = "aef49cc7aa606de2044302e757fa94c8e144818e93487081c4fd319ca858134b",
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
