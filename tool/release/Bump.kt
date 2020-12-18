package tool.release

import com.google.api.client.http.ByteArrayContent
import com.google.api.client.http.GenericUrl
import com.google.api.client.http.HttpHeaders
import com.google.api.client.http.javanet.NetHttpTransport
import java.nio.file.Files
import java.nio.file.Paths


fun postJson(url: String?, authorization: String, accept: String, content: String) {
    NetHttpTransport()
    .createRequestFactory()
    .buildPostRequest(GenericUrl(url), ByteArrayContent.fromString("application/json", content))
    .setHeaders(HttpHeaders().setAuthorization(authorization).setAccept(accept))
    .execute()
}

fun main() {
    val workspaceDirectory = System.getenv("BUILD_WORKSPACE_DIRECTORY")
            ?: throw RuntimeException("Not running from within Bazel workspace")
    val githubToken = System.getenv("GITHUB_TOKEN")
            ?: throw RuntimeException("GITHUB_TOKEN environment variable is not set")
    val repoOwner = System.getenv("GRABL_OWNER")
            ?: throw RuntimeException("GRABL_OWNER environment variable is not set")
    val repoName = System.getenv("GRABL_REPO")
            ?: throw RuntimeException("GRABL_REPO environment variable is not set")

    val versionFile = Paths.get(workspaceDirectory, "VERSION")
    val content = String(Files.readAllBytes(versionFile)).trim()
    val versionComponents = content.split(".").map { it -> Integer.parseInt(it)}.toTypedArray()

    if (versionComponents.size != 3) {
        throw RuntimeException("Version is supposed to have three components: x.y.z")
    }
    versionComponents[versionComponents.lastIndex] += 1

    val newVersion = versionComponents.joinToString(".")
    println("Bumping the version to ${newVersion}")
    Files.write(versionFile, newVersion.toByteArray())

    println("Creating new milestone ${newVersion} in ${repoOwner}/${repoName}")
    postJson("https://api.github.com/repos/${repoOwner}/${repoName}/milestones",
            "Token ${githubToken}",
            "application/vnd.github.v3+json",
            """{"title": "${newVersion}"}""")

}
