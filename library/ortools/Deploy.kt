package library.ortools

import java.io.DataOutputStream
import java.net.HttpURLConnection
import java.net.URL
import java.nio.charset.StandardCharsets.UTF_8
import java.util.*

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
    val destination = URL("$repository/$groupId/$artifactId/$version/$artifactId-$version.txt")
    println("destination: $destination")
    val connection = destination.openConnection() as HttpURLConnection
    connection.requestMethod = "POST"
    connection.connectTimeout = 300000
    connection.connectTimeout = 300000
    connection.doOutput = true

//    connection.setRequestProperty("charset", "utf-8")
    connection.setRequestProperty("Content-length", data.size.toString())
    connection.setRequestProperty("Content-Type", "application/octet-stream")
    connection.setRequestProperty(
            "Authorization",
            "Basic " + String(Base64.getEncoder().encode("$username:$password".toByteArray()))
    )

    try {
        val outputStream = DataOutputStream(connection.outputStream)
        outputStream.write(data)
        outputStream.flush()
    } catch (e: Exception) {
        throw RuntimeException(e)
    }

    println("username: $username, password: $password")
    println("response code: " + connection.responseCode)
    println("response message: " + connection.responseMessage)
//    if (connection.responseCode != HttpURLConnection.HTTP_OK && connection.responseCode != HttpURLConnection.HTTP_CREATED) {
//        try {
//            val inputStream = DataInputStream(connection.inputStream)
//            val reader = BufferedReader(InputStreamReader(inputStream))
//            val output: String = reader.readLine()
//
//            println("There was error while connecting the chat $output")
//            System.exit(0)
//
//        } catch (exception: Exception) {
//            throw Exception("Exception while push the notification  $exception.message")
//        }
//    }
}
