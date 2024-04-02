/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package com.vaticle.dependencies.tool.release.version

import com.vaticle.bazel.distribution.common.Logging.LogLevel.DEBUG
import com.vaticle.bazel.distribution.common.Logging.Logger
import com.vaticle.bazel.distribution.common.shell.Shell
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import kotlin.io.path.exists

val logger = Logger(DEBUG)
val shell = Shell(logger)

val VERSION_FILE_NAMES = arrayOf("VERSION", "VERSION.txt")

fun main() {
    val (workspacePath, branchName, gitUsername, gitEmail) = Config.load()

    shell.execute(listOf("git", "config", "--global", "user.name", gitUsername))
    shell.execute(listOf("git", "config", "--global", "user.email", gitEmail))
    shell.execute(listOf("git", "checkout", branchName), baseDir = workspacePath)

    val versionFile = getVersionFilePath(workspacePath)
    val version = String(Files.readAllBytes(versionFile)).trim()
    val newVersion = bumpVersion(version)

    logger.debug { "Updating VERSION file content to '$newVersion'" }
    Files.write(versionFile, newVersion.toByteArray())

    logger.debug { "Creating Git commit and pushing to the remote repository" }
    gitCommitAndPush(workspacePath, newVersion)
}

fun getVersionFilePath(workspacePath: Path): Path {
    VERSION_FILE_NAMES.forEach {
        val candidate = workspacePath.resolve(it)
        if (candidate.exists()) return candidate
    }
    throw RuntimeException("Could not find any of the following files in ${workspacePath.toAbsolutePath()}: $VERSION_FILE_NAMES")
}

data class Config(val workspacePath: Path, val branchName: String, val gitUsername: String, val gitEmail: String) {
    companion object {
        fun load(): Config {
            return Config(
                workspacePath = Paths.get(getenv("BUILD_WORKSPACE_DIRECTORY", errorMsg = "Not running from within Bazel workspace")),
                branchName = getenv("FACTORY_BRANCH"), gitUsername = getenv("GIT_USERNAME"),
                gitEmail = getenv("GIT_EMAIL")
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

fun gitCommitAndPush(workspacePath: Path, newVersion: String) {
    shell.execute(listOf("git", "add", "VERSION"), baseDir = workspacePath)
    shell.execute(listOf("git", "commit", "-m", "Bump version number to $newVersion"), baseDir = workspacePath)
    val maxRetries = 3
    var retryCount = 0
    while (retryCount < maxRetries) {
        shell.execute(listOf("git", "pull", "--rebase"), baseDir = workspacePath)
        val pushResult = shell.execute(listOf("git", "push"), baseDir = workspacePath, throwOnError = false)
        if (pushResult.exitValue == 0) break
        else {
            // cover the edge case where someone else has already pushed
            retryCount++
            if (retryCount == maxRetries) throw RuntimeException("Exceeded retry limit of [$maxRetries] attempting to push to Git. Aborting.")
        }
    }
}
