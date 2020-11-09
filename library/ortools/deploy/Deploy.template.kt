package library.ortools.deploy

import org.zeroturnaround.exec.ProcessExecutor
import org.zeroturnaround.exec.ProcessResult
import java.math.BigInteger
import java.nio.charset.StandardCharsets.UTF_8
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.security.MessageDigest
import java.util.*

fun main() {
    val username = Objects.requireNonNull(
            System.getenv("DEPLOY_MAVEN_USERNAME"),
            "username should be passed via \$DEPLOY_MAVEN_USERNAME env variable"
    )
    val password = Objects.requireNonNull(
            System.getenv("DEPLOY_MAVEN_PASSWORD"),
            "password should be passed via \$DEPLOY_MAVEN_PASSWORD env variable"
    )

    val repository = "{repository}"
    val otGroupId = "com/google/ortools"
    val otVersion = "{google_or_tools_version}"

    deployOrToolsDarwin(otVersion, username, password, repository, otGroupId)
    deployOrToolsDarwinJava(otVersion, username, password, repository, otGroupId)

    deployOrToolsLinux(otVersion, username, password, repository, otGroupId)
    deployOrToolsLinuxJava(otVersion, username, password, repository, otGroupId)

    deployOrToolsWindows(otVersion, username, password, repository, otGroupId)
    deployOrToolsWindowsJava(otVersion, username, password, repository, otGroupId)
}

private fun deployOrToolsDarwin(otVersion: String, username: String, password: String, repository: String, otGroupId: String) {
    val bazelWorkspace = "google_or_tools_darwin"
    val otDarwin_ArtifactId = "ortools-darwin"
    val otDarwin_JarName = "$otDarwin_ArtifactId-$otVersion.jar"
    val otDarwin_SrcjarName = "$otDarwin_ArtifactId-$otVersion-sources.jar"
    val otDarwin_Pom = Paths.get("external", bazelWorkspace, "pom-runtime.xml")
    val otDarwin_Jar = Paths.get("external", bazelWorkspace, otDarwin_JarName)
    val otDarwin_SrcJar = Paths.get("external", bazelWorkspace, otDarwin_SrcjarName)
    deployMaven(otDarwin_Pom, username, password, repository, otGroupId, otDarwin_ArtifactId, otVersion, "pom")
    deployMaven(otDarwin_Jar, username, password, repository, otGroupId, otDarwin_ArtifactId, otVersion, "jar")
    deployMaven(otDarwin_SrcJar, username, password, repository, otGroupId, otDarwin_ArtifactId, otVersion, "srcjar")
}

private fun deployOrToolsDarwinJava(otVersion: String, username: String, password: String, repository: String, otGroupId: String) {
    val bazelWorkspace = "google_or_tools_darwin"
    val otJava_ArtifactId = "ortools-java"
    val otJava_ArtifactIdRenamed = "ortools-darwin-java"
    val otJava_JarName = "$otJava_ArtifactId-$otVersion.jar"
    val otJava_SrcjarName = "$otJava_ArtifactId-$otVersion-sources.jar"
    val otJava_JavadocName = "$otJava_ArtifactId-$otVersion-javadoc.jar"
    val otJava_Pom = Paths.get("external", bazelWorkspace, "pom-local.xml")
    val otJava_Jar = Paths.get("external", bazelWorkspace, otJava_JarName)
    val otJava_SrcJar = Paths.get("external", bazelWorkspace, otJava_SrcjarName)
    val otJava_Javadoc = Paths.get("external", bazelWorkspace, otJava_JavadocName)
    deployMaven(otJava_Pom, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "pom")
    deployMaven(otJava_Jar, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "jar")
    deployMaven(otJava_SrcJar, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "srcjar")
    deployMaven(otJava_Javadoc, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "javadoc")
}

private fun deployOrToolsLinux(otVersion: String, username: String, password: String, repository: String, otGroupId: String) {
    val bazelWorkspace = "google_or_tools_linux"
    val otLinux_ArtifactId = "ortools-linux-x86-64"
    val otLinux_JarName = "$otLinux_ArtifactId-$otVersion.jar"
    val otLinux_SrcjarName = "$otLinux_ArtifactId-$otVersion-sources.jar"
    val otLinux_Pom = Paths.get("external", bazelWorkspace, "pom-runtime.xml")
    val otLinux_Jar = Paths.get("external", bazelWorkspace, otLinux_JarName)
    val otLinux_SrcJar = Paths.get("external", bazelWorkspace, otLinux_SrcjarName)
    deployMaven(otLinux_Pom, username, password, repository, otGroupId, otLinux_ArtifactId, otVersion, "pom")
    deployMaven(otLinux_Jar, username, password, repository, otGroupId, otLinux_ArtifactId, otVersion, "jar")
    deployMaven(otLinux_SrcJar, username, password, repository, otGroupId, otLinux_ArtifactId, otVersion, "srcjar")
}

private fun deployOrToolsLinuxJava(otVersion: String, username: String, password: String, repository: String, otGroupId: String) {
    val bazelWorkspace = "google_or_tools_linux"
    val otJava_ArtifactId = "ortools-java"
    val otJava_ArtifactIdRenamed = "ortools-linux-x86-64-java"
    val otJava_JarName = "$otJava_ArtifactId-$otVersion.jar"
    val otJava_SrcjarName = "$otJava_ArtifactId-$otVersion-sources.jar"
    val otJava_JavadocName = "$otJava_ArtifactId-$otVersion-javadoc.jar"
    val otJava_Pom = Paths.get("external", bazelWorkspace, "pom-local.xml")
    val otJava_Jar = Paths.get("external", bazelWorkspace, otJava_JarName)
    val otJava_SrcJar = Paths.get("external", bazelWorkspace, otJava_SrcjarName)
    val otJava_Javadoc = Paths.get("external", bazelWorkspace, otJava_JavadocName)
    deployMaven(otJava_Pom, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "pom")
    deployMaven(otJava_Jar, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "jar")
    deployMaven(otJava_SrcJar, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "srcjar")
    deployMaven(otJava_Javadoc, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "javadoc")
}

private fun deployOrToolsWindows(otVersion: String, username: String, password: String, repository: String, otGroupId: String) {
    val otWindows_ArtifactId = "ortools-win32-x86-64"
    val otWindows_JarName = "$otWindows_ArtifactId-$otVersion.jar"
    val otWindows_SrcjarName = "$otWindows_ArtifactId-$otVersion-sources.jar"
    val otWindows_Pom = Paths.get("external", "google_or_tools_windows", "pom-runtime.xml")
    val otWindows_Jar = Paths.get("external", "google_or_tools_windows", otWindows_JarName)
    val otWindows_SrcJar = Paths.get("external", "google_or_tools_windows", otWindows_SrcjarName)
    deployMaven(otWindows_Pom, username, password, repository, otGroupId, otWindows_ArtifactId, otVersion, "pom")
    deployMaven(otWindows_Jar, username, password, repository, otGroupId, otWindows_ArtifactId, otVersion, "jar")
    deployMaven(otWindows_SrcJar, username, password, repository, otGroupId, otWindows_ArtifactId, otVersion, "srcjar")
}

private fun deployOrToolsWindowsJava(otVersion: String, username: String, password: String, repository: String, otGroupId: String) {
    val bazelWorkspace = "google_or_tools_windows"
    val otJava_ArtifactId = "ortools-java"
    val otJava_ArtifactIdRenamed = "ortools-win32-x86-64-java"
    val otJava_JarName = "$otJava_ArtifactId-$otVersion.jar"
    val otJava_SrcjarName = "$otJava_ArtifactId-$otVersion-sources.jar"
    val otJava_JavadocName = "$otJava_ArtifactId-$otVersion-javadoc.jar"
    val otJava_Pom = Paths.get("external", bazelWorkspace, "pom-local.xml")
    val otJava_Jar = Paths.get("external", bazelWorkspace, otJava_JarName)
    val otJava_SrcJar = Paths.get("external", bazelWorkspace, otJava_SrcjarName)
    val otJava_Javadoc = Paths.get("external", bazelWorkspace, otJava_JavadocName)
    deployMaven(otJava_Pom, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "pom")
    deployMaven(otJava_Jar, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "jar")
    deployMaven(otJava_SrcJar, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "srcjar")
    deployMaven(otJava_Javadoc, username, password, repository, otGroupId, otJava_ArtifactIdRenamed, otVersion, "javadoc")
}

private fun deployMaven(source: Path, username: String, password: String, repository: String, groupId: String, artifactId: String, version: String, type: String) {
    val sourceChecksumMd5 = md5(source)
    val sourceChecksumSha1 = sha1(source)
    val targetArtifact = when (type) {
        "pom" -> "$artifactId-$version.pom"
        "jar" -> "$artifactId-$version.jar"
        "srcjar" -> "$artifactId-$version-sources.jar"
        "javadoc" -> "$artifactId-$version-javadoc.jar"
        else -> throw RuntimeException("Unable to upload a file of type '$type'.")
    }
    val target = "$repository/$groupId/$artifactId/$version/$targetArtifact"

    deployFile(username, password, source, target)
    deployFile(username, password, sourceChecksumMd5, "$target.md5")
    deployFile(username, password, sourceChecksumSha1, "$target.sha1")
}

private fun deployFile(username: String, password: String, source: Path, target: String) {
    print("uploading '$source' to '$target'. exit code: ")
    shell(
            "curl " +
                    "--silent " +
                    "--write-out \"%{http_code}\" " +
                    "-u $username:$password " +
                    "--upload-file $source " +
                    target
    )
    println() // print newline after the exit code is printed
}

private fun shell(script: String): ProcessResult {
    val scriptArray = script.split(" ")
    val builder = ProcessExecutor(scriptArray)
            .readOutput(true)
            .redirectOutput(System.out)
            .redirectError(System.err)
            .exitValueNormal()

    return builder.execute()
}

private fun md5(source: Path): Path {
    val destination = Paths.get(source.toAbsolutePath().toString() + ".md5")
    val hasher = MessageDigest.getInstance("MD5");
    hasher.update(Files.readAllBytes(source));
    val digest = hasher.digest()
    // the resulting hash must have 32 characters. it is padded by leading zeros when it's less than that
    val md5Padded = String.format("%1$32s", toHex(digest).toLowerCase()).replace(" ", "0")
    Files.write(destination, md5Padded.toByteArray(UTF_8))
    return destination
}

private fun sha1(source: Path): Path {
    val destination = Paths.get(source.toAbsolutePath().toString() + ".sha1")
    val hasher = MessageDigest.getInstance("SHA-1");
    hasher.update(Files.readAllBytes(source));
    val digest = hasher.digest()
    // the resulting hash must have 40 characters. it is padded by leading zeros when it's less than that
    val sha1Padded = String.format("%1$40s", toHex(digest).toLowerCase()).replace(" ", "0")
    Files.write(destination, sha1Padded.toByteArray(UTF_8))
    return destination
}

private fun toHex(bytes: ByteArray): String {
    val bigInteger = BigInteger(1, bytes)
    return bigInteger.toString(16)
}
