package library.ortools

import org.zeroturnaround.exec.ProcessExecutor
import org.zeroturnaround.exec.ProcessResult
import java.lang.RuntimeException
import java.nio.file.Path
import java.nio.file.Paths
import java.util.*

fun main() {
    val DEPLOY_MAVEN_USERNAME = Objects.requireNonNull(System.getenv("DEPLOY_MAVEN_USERNAME"), "username should be passed via \$DEPLOY_MAVEN_USERNAME env variable")
    val DEPLOY_MAVEN_PASSWORD = Objects.requireNonNull(System.getenv("DEPLOY_MAVEN_PASSWORD"), "password should be passed via \$DEPLOY_MAVEN_PASSWORD env variable")

    val REPOSITORY_URL = "https://repo.grakn.ai/repository/maven"
    val GROUP_ID = "com/google/ortools"
    val VERSION = "8.0.8283"

    val ORTOOLS_DARWIN_ARTIFACT_ID = "ortools-darwin-test-6"
    val ORTOOLS_DARWIN_POM_PATH = Paths.get("external/ortools_osx/pom-runtime.xml")
//    val ORTOOLS_DARWIN_JAR_PATH = Paths.get("external/ortools_osx/$ORTOOLS_DARWIN_ARTIFACT_ID-$VERSION.jar")
    val ORTOOLS_DARWIN_JAR_PATH = Paths.get("external/ortools_osx/ortools-darwin-8.0.8283.jar")
//    val ORTOOLS_DARWIN_SRCJAR_PATH = Paths.get("external/ortools_osx/$ORTOOLS_DARWIN_ARTIFACT_ID-$VERSION-sources.jar")
    val ORTOOLS_DARWIN_SRCJAR_PATH = Paths.get("external/ortools_osx/ortools-darwin-8.0.8283-sources.jar")

    deployMaven(ORTOOLS_DARWIN_POM_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_DARWIN_ARTIFACT_ID, VERSION, "", "pom")
    deployMaven(ORTOOLS_DARWIN_JAR_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_DARWIN_ARTIFACT_ID, VERSION,  "", "jar")
    deployMaven(ORTOOLS_DARWIN_SRCJAR_PATH, DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, ORTOOLS_DARWIN_ARTIFACT_ID, VERSION, "-sources","jar")
}

fun deployMaven(source: Path, username: String, password: String, repository: String, groupId: String, artifactId: String, version: String, modifier: String, extension: String) {
    val acceptedExtensions = listOf("pom", "jar", "md5", "sha1", "asc")
    if (!acceptedExtensions.contains(extension))
        throw RuntimeException("Unable to upload a file of type $extension. Only $acceptedExtensions are allowed.")

    shellScript(
            "curl " +
            "--write-out \"%{http_code}\" " +
            "-u $username:$password " +
            "--upload-file $source " +
            "$repository/$groupId/$artifactId/$version/$artifactId-$version$modifier.$extension"
    )
}

fun shellScript(script: String): ProcessResult {
    val scriptArray = script.split(" ")
    val builder = ProcessExecutor(scriptArray)
            .readOutput(true)
            .redirectOutput(System.out)
            .redirectError(System.err)
            .exitValueNormal()
    return builder.execute()
}