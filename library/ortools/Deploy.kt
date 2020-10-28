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
    val DEPLOY_MAVEN_USERNAME = Objects.requireNonNull(System.getenv("DEPLOY_MAVEN_USERNAME"), "username should be passed via \$DEPLOY_MAVEN_USERNAME env variable")
    val DEPLOY_MAVEN_PASSWORD = Objects.requireNonNull(System.getenv("DEPLOY_MAVEN_PASSWORD"), "password should be passed via \$DEPLOY_MAVEN_PASSWORD env variable")

    val REPOSITORY_URL = "https://repo.grakn.ai/repository/maven"
    val GROUP_ID = "com/google/ortools"
    val VERSION = "8.0.8283"

    /*
     * ortools-darwin
     */
    val ORTOOLS_DARWIN_ARTIFACT_ID = "ortools-darwin"
    val ORTOOLS_DARWIN_POM_PATH = Paths.get("external/ortools_osx/pom-runtime.xml")
    val ORTOOLS_DARWIN_JAR_PATH = Paths.get("external/ortools_osx/$ORTOOLS_DARWIN_ARTIFACT_ID-$VERSION.jar")
    val ORTOOLS_DARWIN_SRCJAR_PATH = Paths.get("external/ortools_osx/$ORTOOLS_DARWIN_ARTIFACT_ID-$VERSION-sources.jar")

    deployMaven(ORTOOLS_DARWIN_POM_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_DARWIN_ARTIFACT_ID, VERSION, "", "pom")
    deployMaven(ORTOOLS_DARWIN_JAR_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_DARWIN_ARTIFACT_ID, VERSION,  "", "jar")
    deployMaven(ORTOOLS_DARWIN_SRCJAR_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_DARWIN_ARTIFACT_ID, VERSION, "-sources","jar")

    /*
     * ortools-java-darwin
     */
    val ORTOOLS_JAVA_ARTIFACT_ID = "ortools-java-darwin"
    val ORTOOLS_JAVA_POM_PATH = Paths.get("external/ortools_osx/pom-local.xml")
    val ORTOOLS_JAVA_JAR_PATH = Paths.get("external/ortools_osx/ortools-java-$VERSION.jar")
    val ORTOOLS_JAVA_SRCJAR_PATH = Paths.get("external/ortools_osx/ortools-java-$VERSION-sources.jar")
    val ORTOOLS_JAVA_JAVADOC_PATH = Paths.get("external/ortools_osx/ortools-java-$VERSION-javadoc.jar")

    deployMaven(ORTOOLS_JAVA_POM_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_JAVA_ARTIFACT_ID, VERSION, "", "pom")
    deployMaven(ORTOOLS_JAVA_JAR_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_JAVA_ARTIFACT_ID, VERSION,  "", "jar")
    deployMaven(ORTOOLS_JAVA_SRCJAR_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_JAVA_ARTIFACT_ID, VERSION, "-sources","jar")
    deployMaven(ORTOOLS_JAVA_JAVADOC_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_JAVA_ARTIFACT_ID, VERSION, "-javadoc","jar")
}

fun deployMaven(source: Path, username: String, password: String, repository: String, groupId: String, artifactId: String, version: String, modifier: String, extension: String) {
    val acceptedExtensions = listOf("pom", "jar", "md5", "sha1", "asc")
    if (!acceptedExtensions.contains(extension))
        throw RuntimeException("Unable to upload a file of type $extension. Only $acceptedExtensions are allowed.")

    shell(
            "curl " +
                    "--write-out \"%{http_code}\" " +
                    "-u $username:$password " +
                    "--upload-file $source " +
                    "$repository/$groupId/$artifactId/$version/$artifactId-$version$modifier.$extension"
    )

    val md5File = md5(source)
    shell(
            "curl " +
                    "--write-out \"%{http_code}\" " +
                    "-u $username:$password " +
                    "--upload-file $md5File " +
                    "$repository/$groupId/$artifactId/$version/$artifactId-$version$modifier.$extension.md5"
    )

    val sha1File = sha1(source)
    shell(
            "curl " +
                    "--write-out \"%{http_code}\" " +
                    "-u $username:$password " +
                    "--upload-file $sha1File " +
                    "$repository/$groupId/$artifactId/$version/$artifactId-$version$modifier.$extension.sha1"
    )
}

fun md5(source: Path): Path {
    val destination = Paths.get(source.toAbsolutePath().toString() + ".md5")
    val hasher = MessageDigest.getInstance("MD5");
    hasher.update(Files.readAllBytes(source));
    val digest = hasher.digest()
    val md5 = toHex(digest).toUpperCase()
    Files.write(destination, md5.toByteArray(UTF_8))
    return destination
}

fun sha1(source: Path): Path {
    val destination = Paths.get(source.toAbsolutePath().toString() + ".sha1")
    val hasher = MessageDigest.getInstance("SHA-1");
    hasher.update(Files.readAllBytes(source));
    val digest = hasher.digest()
    val sha1 = toHex(digest).toUpperCase()
    Files.write(destination, sha1.toByteArray(UTF_8))
    return destination
}

fun shell(script: String): ProcessResult {
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
