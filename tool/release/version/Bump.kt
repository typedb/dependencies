/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package com.vaticle.dependencies.tool.release.version

import com.vaticle.bazel.distribution.common.Logging.LogLevel.DEBUG
import com.vaticle.bazel.distribution.common.Logging.Logger
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

    private val workspacePath = Paths.get(System.getenv("BUILD_WORKSPACE_DIRECTORY"))
    private val logger = Logger(DEBUG)

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
}
