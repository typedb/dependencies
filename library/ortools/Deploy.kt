package library.ortools

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

    val repository = "https://repo.grakn.ai/repository/maven"
    val otGroupId = "com/google/ortools"
    val otVersion = "8.0.8283"

    /*
     * Google OT Native artifacts (Darwin)
     */
    val otDarwin_ArtifcatId = "ortools-darwin"
    val otDarwin_JarName = "ortools-darwin-$otVersion.jar"
    val otDarwin_SrcjarName = "ortools-darwin-$otVersion-sources.jar"
    val otDarwin_Pom = Paths.get("external", "google_ortools_darwin", "pom-runtime.xml")
    val otDarwin_Jar = Paths.get("external", "google_ortools_darwin", otDarwin_JarName)
    val otDarwin_SrcJar = Paths.get("external", "google_ortools_darwin", otDarwin_SrcjarName)
    deployMaven(otDarwin_Pom, username, password, repository, otGroupId, otDarwin_ArtifcatId, otVersion, "pom")
    deployMaven(otDarwin_Jar, username, password, repository, otGroupId, otDarwin_ArtifcatId, otVersion, "jar")
    deployMaven(otDarwin_SrcJar, username, password, repository, otGroupId, otDarwin_ArtifcatId, otVersion, "srcjar")

    /*
     * Google OT JNI artifacts (Darwin)
     */
    val otJava_ArtifactId = "ortools-java"
    val otJava_JarName = "ortools-java-$otVersion.jar"
    val otJava_SrcjarName = "ortools-java-$otVersion-sources.jar"
    val otJava_JavadocName = "ortools-java-$otVersion-javadoc.jar"
    val otJava_PomP = Paths.get("external", "google_ortools_darwin", "pom-local.xml")
    val otJava_Jar = Paths.get("external", "google_ortools_darwin", otJava_JarName)
    val otJava_SrcJar = Paths.get("external", "google_ortools_darwin", otJava_SrcjarName)
    val otJava_Javadoc = Paths.get("external", "google_ortools_darwin", otJava_JavadocName)
    deployMaven(otJava_PomP, username, password, repository, otGroupId, otJava_ArtifactId, otVersion, "pom")
    deployMaven(otJava_Jar, username, password, repository, otGroupId, otJava_ArtifactId, otVersion,  "jar")
    deployMaven(otJava_SrcJar, username, password, repository, otGroupId, otJava_ArtifactId, otVersion, "srcjar")
    deployMaven(otJava_Javadoc, username, password, repository, otGroupId, otJava_ArtifactId, otVersion, "javadoc")
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
