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

// TODO:
//  - refactor and use HttpUrlConnection rather than curl
//  - get ortools-java-darwin named ortools-java
//  - deploy ortools for linux and windows
//  - get bazel to depend on the right ortools depending on the OS

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
    val groupId = "com/google/ortools"
    val version = "8.0.8283"

    /*
     * ortools-darwin
     */
    val orToolsDarwin_ArtifcatId = "ortools-darwin"
    val orToolsDarwin_PomFile = Paths.get("external/ortools_osx/pom-runtime.xml")
    val orToolsDarwin_JarFile = Paths.get("external/ortools_osx/$orToolsDarwin_ArtifcatId-$version.jar")
    val orToolsDarwin_SrcJarFile = Paths.get("external/ortools_osx/$orToolsDarwin_ArtifcatId-$version-sources.jar")

    deployMaven(orToolsDarwin_PomFile, username, password, repository, groupId, orToolsDarwin_ArtifcatId, version, "pom")
    deployMaven(orToolsDarwin_JarFile, username, password, repository, groupId, orToolsDarwin_ArtifcatId, version, "jar")
    deployMaven(orToolsDarwin_SrcJarFile, username, password, repository, groupId, orToolsDarwin_ArtifcatId, version, "srcjar")

    /*
     * ortools-java-darwin
     */
    val orToolsJava_ArtifactId = "ortools-java-darwin"
    val orToolsJava_PomFile = Paths.get("external/ortools_osx/pom-local.xml")
    val orToolsJava_JarFile = Paths.get("external/ortools_osx/ortools-java-$version.jar")
    val orToolsJava_SrcJarFile = Paths.get("external/ortools_osx/ortools-java-$version-sources.jar")
    val orToolsJava_JavadocFile = Paths.get("external/ortools_osx/ortools-java-$version-javadoc.jar")


    deployMaven(orToolsJava_PomFile, username, password, repository, groupId, orToolsJava_ArtifactId, version, "pom")
    deployMaven(orToolsJava_JarFile, username, password, repository, groupId, orToolsJava_ArtifactId, version,  "jar")
    deployMaven(orToolsJava_SrcJarFile, username, password, repository, groupId, orToolsJava_ArtifactId, version, "srcjar")
    deployMaven(orToolsJava_JavadocFile, username, password, repository, groupId, orToolsJava_ArtifactId, version, "javadoc")
}

fun deployMaven(source: Path, username: String, password: String, repository: String, groupId: String, artifactId: String, version: String, type: String) {
    val artifactFileName = when (type) {
        "pom" -> "$artifactId-$version.pom"
        "jar" -> "$artifactId-$version.jar"
        "srcjar" -> "$artifactId-$version-sources.jar"
        "javadoc" -> "$artifactId-$version-javadoc.jar"
        else -> throw RuntimeException("Unable to upload a file of type '$type'.")
    }
    shell(
            "curl " +
                    "--write-out \"%{http_code}\" " +
                    "-u $username:$password " +
                    "--upload-file $source " +
                    "$repository/$groupId/$artifactId/$version/$artifactFileName"
    )

    val md5File = md5(source)
    shell(
            "curl " +
                    "--write-out \"%{http_code}\" " +
                    "-u $username:$password " +
                    "--upload-file $md5File " +
                    "$repository/$groupId/$artifactId/$version/$artifactFileName.md5"
    )

    val sha1File = sha1(source)
    shell(
            "curl " +
                    "--write-out \"%{http_code}\" " +
                    "-u $username:$password " +
                    "--upload-file $sha1File " +
                    "$repository/$groupId/$artifactId/$version/$artifactFileName.sha1"
    )
}

fun md5(source: Path): Path {
    val destination = Paths.get(source.toAbsolutePath().toString() + ".md5")
    val hasher = MessageDigest.getInstance("MD5");
    hasher.update(Files.readAllBytes(source));
    val digest = hasher.digest()
    val md5Padded = String.format("%1$32s", toHex(digest).toLowerCase()).replace(" ", "0")
    Files.write(destination, md5Padded.toByteArray(UTF_8))
    return destination
}

fun sha1(source: Path): Path {
    val destination = Paths.get(source.toAbsolutePath().toString() + ".sha1")
    val hasher = MessageDigest.getInstance("SHA-1");
    hasher.update(Files.readAllBytes(source));
    val digest = hasher.digest()
    val sha1Padded = String.format("%1$40s", toHex(digest).toLowerCase()).replace(" ", "0")
    Files.write(destination, sha1Padded.toByteArray(UTF_8))
    return destination
}

fun shell(script: String): ProcessResult {
    println("script: $script")
    val scriptArray = script.split(" ")
    val builder = ProcessExecutor(scriptArray)
            .readOutput(true)
            .redirectOutput(System.out)
            .redirectError(System.err)
            .exitValueNormal()
    return builder.execute()
}

fun toHex(bytes: ByteArray): String {
    val bigInteger = BigInteger(1, bytes)
    return bigInteger.toString(16)
}
