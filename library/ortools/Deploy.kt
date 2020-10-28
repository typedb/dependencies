package library.ortools

import java.io.DataOutputStream
import java.net.HttpURLConnection
import java.net.URL
import java.nio.charset.StandardCharsets.UTF_8
import java.util.*
import javax.net.ssl.HttpsURLConnection

fun main() {
    val DEPLOY_MAVEN_USERNAME = Objects.requireNonNull(System.getenv("DEPLOY_MAVEN_USERNAME"), "username should be passed via \$DEPLOY_MAVEN_USERNAME env variable")
    val DEPLOY_MAVEN_PASSWORD = Objects.requireNonNull(System.getenv("DEPLOY_MAVEN_PASSWORD"), "password should be passed via \$DEPLOY_MAVEN_PASSWORD env variable")

    val REPOSITORY_URL = "https://repo.grakn.ai/repository/maven"
    val GROUP_ID = "com/google/ortools"
    val VERSION = "8.0.8283"

//    val ORTOOLS_DARWIN_ARTIFACT_ID = "ortools-darwin"
//    val ORTOOLS_DARWIN_POM_PATH = "external/ortools_osx/pom-runtime.xml"
//    val ORTOOLS_DARWIN_JAR_PATH = "external/ortools_osx/$ORTOOLS_DARWIN_ARTIFACT_ID-$VERSION.jar"
//    val ORTOOLS_DARWIN_SRCJAR_PATH = "external/ortools_osx/$ORTOOLS_DARWIN_ARTIFACT_ID-$VERSION-sources.jar"
//
    post("hello-world".toByteArray(UTF_8), DEPLOY_MAVEN_USERNAME, DEPLOY_MAVEN_PASSWORD, REPOSITORY_URL, GROUP_ID, "test", VERSION)
}

fun post(data: ByteArray, username: String, password: String, repository: String, groupId: String, artifactId: String, version: String) {
//    curl --write-out "%{http_code}" -u "$DEPLOY_MAVEN_USERNAME":"$DEPLOY_MAVEN_PASSWORD" --upload-file "$ORTOOLS_DARWIN_POM_PATH" "$REPOSITORY_URL"/"$GROUP_ID"/"$ORTOOLS_DARWIN_ARTIFACT_ID"/"$VERSION"/"$ORTOOLS_DARWIN_ARTIFACT_ID"-"$VERSION".pom
}
