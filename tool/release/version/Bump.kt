package com.vaticle.dependencies.tool.release.version

import com.vaticle.bazel.distribution.common.Logging.LogLevel.DEBUG
import com.vaticle.bazel.distribution.common.Logging.Logger
import com.vaticle.bazel.distribution.common.shell.Shell
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths

val logger = Logger(DEBUG)

fun bumpVersion(version: String): String {
    val versionComponents = version.split(".").toTypedArray()
    if (versionComponents.size != 3) throw RuntimeException("Version is supposed to have three components: x.y.z")
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
            throw RuntimeException("invalid version: $version")
        }
    }
    versionComponents[versionComponents.lastIndex] = lastVersionComponent
    return versionComponents.joinToString(".")
}

fun gitCommitAndPush(workspacePath: Path, newVersion: String) {
    val shell = Shell(logger)
    shell.execute(listOf("git", "checkout", "master"), baseDir = workspacePath)
    shell.execute(listOf("git", "add", "VERSION"), baseDir = workspacePath)
    shell.execute(listOf("git", "commit", "-m", "\"Bump version number to $newVersion\""), baseDir = workspacePath)
    val maxRetries = 3
    var retryCount = 0
    while (retryCount < maxRetries) {
        shell.execute(listOf("git", "pull"), baseDir = workspacePath)
        try {
            shell.execute(listOf("git", "push"), baseDir = workspacePath)
            break
        } catch (e: Exception) {
            // cover the unlikely but possible edge case where someone else has already pushed
            retryCount++
            if (retryCount == maxRetries) throw e
        }
    }
}

fun main() {
    val workspaceDirectory = System.getenv("BUILD_WORKSPACE_DIRECTORY")
            ?: throw RuntimeException("Not running from within Bazel workspace")
    val workspacePath = Paths.get(workspaceDirectory)
    val versionFile = workspacePath.resolve("VERSION")
    val version = String(Files.readAllBytes(versionFile)).trim()
    val newVersion = bumpVersion(version)

    logger.debug { "Bumping the version to $newVersion" }
    Files.write(versionFile, newVersion.toByteArray())

    gitCommitAndPush(workspacePath, newVersion)
}
