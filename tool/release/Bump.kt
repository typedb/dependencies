package com.vaticle.dependencies.tool.release

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

fun bumpVersion(version: String): String {
    val versionComponents = version.split(".").toTypedArray()

    if (versionComponents.size != 3) {
        throw RuntimeException("Version is supposed to have three components: x.y.z")
    }
    var lastVersionComponent = versionComponents[versionComponents.lastIndex]

    try {
        // regular version component ("0")
        lastVersionComponent = (Integer.parseInt(lastVersionComponent) + 1).toString()
    } catch (a: NumberFormatException) {
        // must be a snapshot version "0-alpha-X" where X needs to be incremented
        val versionSubComponents = lastVersionComponent.split("-").toTypedArray()
        try {
            versionSubComponents[versionSubComponents.lastIndex] = (
                    Integer.parseInt(versionSubComponents[versionSubComponents.lastIndex]) + 1
                    ).toString()
            lastVersionComponent = versionSubComponents.joinToString("-")
        } catch (b: NumberFormatException) {
            throw RuntimeException("invalid version: ${version}")
        }
    }
    versionComponents[versionComponents.lastIndex] = lastVersionComponent
    return versionComponents.joinToString(".")
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
    val version = String(Files.readAllBytes(versionFile)).trim()
    val newVersion = bumpVersion(version)

    println("Bumping the version to ${newVersion}")
    Files.write(versionFile, newVersion.toByteArray())

    println("Creating new milestone ${newVersion} in ${repoOwner}/${repoName}")
    postJson("https://api.github.com/repos/${repoOwner}/${repoName}/milestones",
            "Token ${githubToken}",
            "application/vnd.github.v3+json",
            """{"title": "${newVersion}"}""")

}