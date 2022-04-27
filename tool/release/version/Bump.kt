package com.vaticle.dependencies.tool.release.version

import com.vaticle.bazel.distribution.common.Logging.LogLevel.DEBUG
import com.vaticle.bazel.distribution.common.Logging.Logger
import com.vaticle.bazel.distribution.common.shell.Shell
import com.vaticle.bazel.distribution.common.shell.Shell.Command.Companion.arg
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import kotlin.io.path.exists

val logger = Logger(DEBUG)
val shell = Shell(logger)

fun main() {
    val (workspacePath, branchName, gitUsername, gitEmail, gitToken) = Config.load()

    shell.execute(listOf("git", "config", "--global", "user.name", gitUsername))
    shell.execute(listOf("git", "config", "--global", "user.email", gitEmail))
    shell.execute(listOf("git", "checkout", branchName), baseDir = workspacePath)

    val versionFile = workspacePath.resolve("VERSION")
    if (!versionFile.exists()) throw RuntimeException("File not found: VERSION")
    val version = String(Files.readAllBytes(versionFile)).trim()
    val newVersion = bumpVersion(version)

    logger.debug { "Updating VERSION file content to '$newVersion'" }
    Files.write(versionFile, newVersion.toByteArray())

    logger.debug { "Creating Git commit and pushing to the remote repository" }
    val remoteURL = getRemoteURL(workspacePath, gitToken)
    gitCommitAndPush(workspacePath, newVersion, remoteURL)
}

data class Config(val workspacePath: Path, val branchName: String, val gitUsername: String, val gitEmail: String, val gitToken: String) {
    companion object {
        fun load(): Config {
            return Config(
                workspacePath = Paths.get(getenv("BUILD_WORKSPACE_DIRECTORY", errorMsg = "Not running from within Bazel workspace")),
                branchName = getenv("GRABL_BRANCH"),
                gitUsername = getenv("GIT_USERNAME"),
                gitEmail = getenv("GIT_EMAIL"),
                gitToken = getenv("GIT_TOKEN")
            )
        }

        private fun getenv(name: String, errorMsg: String = "$name environment variable is not set"): String {
            return System.getenv(name) ?: throw RuntimeException(errorMsg)
        }
    }
}

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

fun getRemoteURL(workspacePath: Path, gitToken: String): String {
    val gitRemoteOutput = shell.execute(listOf("git", "remote", "-v"), baseDir = workspacePath).outputString()
    val regex = Regex("git@github\\.com:([^/]+)/([^/]+)\\.git")
    val matchedGroups = regex.find(gitRemoteOutput)?.groupValues
    if (matchedGroups == null || matchedGroups.size < 3) {
        throw RuntimeException("Unable to parse 'git remote' output '$gitRemoteOutput'")
    }
    val (_, orgName, repoName) = matchedGroups
    return "https://$gitToken@github.com/$orgName/$repoName.git"
}

fun gitCommitAndPush(workspacePath: Path, newVersion: String, remoteURL: String) {
    shell.execute(listOf("git", "add", "VERSION"), baseDir = workspacePath)
    shell.execute(listOf("git", "commit", "-m", "Bump version number to $newVersion"), baseDir = workspacePath)
    val maxRetries = 3
    var retryCount = 0
    while (retryCount < maxRetries) {
        shell.execute(listOf("git", "pull", "--rebase"), baseDir = workspacePath)
        val pushCmd = Shell.Command(arg("git"), arg("push"), arg(remoteURL, printable = false))
        val pushResult = shell.execute(pushCmd, baseDir = workspacePath, outputIsSensitive = true, throwOnError = false)
        if (pushResult.exitValue == 0) break
        else {
            // cover the unlikely but possible edge case where someone else has already pushed
            retryCount++
            if (retryCount == maxRetries) throw RuntimeException("Exceeded retry limit of [$maxRetries] attempting to push to Git. Aborting.")
        }
    }
}
