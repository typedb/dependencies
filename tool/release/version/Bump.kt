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
import java.util.concurrent.Callable
import kotlin.system.exitProcess
import picocli.CommandLine
import picocli.CommandLine.Option
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.node.ObjectNode

object Bump : Callable<Int> {
    private val HELP_TEXT_ALLOWED_FILE_TYPES = "Must be one of ${VersionFileType.types()}"

    @Option(names = ["--file"], description = ["The path of the file."])
    private lateinit var file: String

    @Option(names = ["--type"], description = ["The type of the file."])
    private lateinit var type: String

    @Option(names = ["--branch"], description = ["The git branch to commit the changes to."])
    private lateinit var branch: String

    private val workspacePath = Paths.get(System.getenv("BUILD_WORKSPACE_DIRECTORY"))
    private val logger = Logger(DEBUG)
    private val shell = Shell(logger)

    private const val LABEL_VERSION = "version"

    @JvmStatic
    fun main(args: Array<String>): Unit = exitProcess(CommandLine(Bump).execute(*args))

    private enum class VersionFileType(val stringValue: String) {
        TEXT("text"),
        PACKAGE_JSON("package-json");

        companion object {
            fun types() = VersionFileType.values().map { it.stringValue }

            fun from(stringValue: String): VersionFileType {
                return when (stringValue) {
                    TEXT.stringValue -> TEXT
                    PACKAGE_JSON.stringValue -> PACKAGE_JSON
                    else -> throw RuntimeException("$HELP_TEXT_ALLOWED_FILE_TYPES. Got $stringValue.")
                }
            }
        }
    }

    override fun call(): Int {
        val path = workspacePath.resolve(file)
        val type = VersionFileType.from(type)

        logger.debug { "Updating version for file ${path.toAbsolutePath()} of type ${type.stringValue}" }
        val nextVersion = incrementAndWriteVersion(path, type)
        logger.debug { "Updated version for file ${path.toAbsolutePath()} to '$nextVersion'" }

        logger.debug { "Creating Git commit and pushing to the remote repository" }
        gitCommitAndPush(path, nextVersion)
        return 0
    }

    private fun incrementAndWriteVersion(path: Path, type: VersionFileType) =
        when (type) {
            VersionFileType.TEXT -> {
                val version = String(Files.readAllBytes(path)).trim()
                val nextVersion = nextVersion(version)
                Files.write(path, nextVersion.toByteArray())
                nextVersion
            }

            VersionFileType.PACKAGE_JSON -> {
                val objectMapper = ObjectMapper()
                val json = objectMapper.readTree(path.toFile())
                val version = json[LABEL_VERSION].asText()
                val nextVersion = nextVersion(version)
                (json as ObjectNode).put(LABEL_VERSION, nextVersion)
                objectMapper.writerWithDefaultPrettyPrinter().writeValue(path.toFile(), json)
                nextVersion
            }
        }

    private fun nextVersion(version: String): String {
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

    data class Config(val gitUsername: String, val gitEmail: String) {
        companion object {
            fun load() = Config(gitUsername = getenv("GIT_USERNAME"), gitEmail = getenv("GIT_EMAIL"))

            private fun getenv(name: String, errorMsg: String = "$name environment variable is not set") =
                System.getenv(name) ?: throw RuntimeException(errorMsg)
        }
    }

    private fun gitCommitAndPush(path: Path, newVersion: String) {
        val (gitUsername, gitEmail) = Config.load()

        shell.execute(listOf("git", "config", "--global", "user.name", gitUsername))
        shell.execute(listOf("git", "config", "--global", "user.email", gitEmail))
        shell.execute(listOf("git", "checkout", branch), baseDir = workspacePath)
        shell.execute(listOf("git", "add", path.toAbsolutePath().toString()), baseDir = workspacePath)
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
}
