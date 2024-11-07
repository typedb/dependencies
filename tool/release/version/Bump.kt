/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package com.vaticle.dependencies.tool.release.version

import com.fasterxml.jackson.core.JsonPointer
import com.typedb.bazel.distribution.common.Logging.LogLevel.DEBUG
import com.typedb.bazel.distribution.common.Logging.Logger
import java.nio.file.Files
import java.nio.file.Path
import java.nio.file.Paths
import java.util.concurrent.Callable
import kotlin.system.exitProcess
import picocli.CommandLine
import picocli.CommandLine.Option
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.node.ObjectNode
import com.vdurmont.semver4j.Semver

object Bump : Callable<Int> {
    private val HELP_TEXT_ALLOWED_FILE_TYPES = "Must be one of ${VersionFileType.stringValues()}"

    @Option(names = ["--file"], description = ["The path of the file."])
    private lateinit var file: String

    @Option(names = ["--type"], description = ["The type of the file."])
    private lateinit var type: String

    @Option(names = ["--json-pointer"], description = ["The JSON Pointer for the version string in the given file e.g. /version"])
    private lateinit var jsonPointer: String

    private val workspacePath = Paths.get(System.getenv("BUILD_WORKSPACE_DIRECTORY"))
    private val logger = Logger(DEBUG)

    @JvmStatic
    fun main(args: Array<String>): Unit = exitProcess(CommandLine(Bump).execute(*args))

    private enum class VersionFileType(val stringValue: String) {
        TEXT("text"),
        JSON("json");

        companion object {
            fun stringValues() = VersionFileType.values().map { it.stringValue }

            fun from(stringValue: String): VersionFileType {
                return when (stringValue) {
                    TEXT.stringValue -> TEXT
                    JSON.stringValue -> JSON
                    else -> throw RuntimeException("$HELP_TEXT_ALLOWED_FILE_TYPES. Got $stringValue.")
                }
            }
        }
    }

    override fun call(): Int {
        val path = workspacePath.resolve(file)
        val type = VersionFileType.from(type)

        logger.debug { "Incrementing version for file ${path.toAbsolutePath()} of type ${type.stringValue}" }
        val versionPair = incrementAndWriteVersion(path, type)
        logger.debug { "Incremented version for file ${path.toAbsolutePath()} from '${versionPair.first} to '${versionPair.second}'" }
        return 0
    }

    private fun incrementAndWriteVersion(path: Path, type: VersionFileType) =
        when (type) {
            VersionFileType.TEXT -> {
                val version = String(Files.readAllBytes(path)).trim()
                val newVersion = nextPatchVersion(version)

                Files.write(path, newVersion.toByteArray())
                Pair(version, newVersion)
            }

            VersionFileType.JSON -> {
                val objectMapper = ObjectMapper()
                val jsonPointer = JsonPointer.compile(jsonPointer)

                val json = objectMapper.readTree(path.toFile())
                val versionParent = json.at(jsonPointer.head())
                val version = json.at(jsonPointer).asText()
                val newVersion = nextPatchVersion(version)

                val versionKey = jsonPointer.last().toString().replace(JsonPointer.SEPARATOR.toString(), "")
                (versionParent as ObjectNode).put(versionKey, newVersion)
                objectMapper.writerWithDefaultPrettyPrinter().writeValue(path.toFile(), json)
                Pair(version, newVersion)
            }
        }

    private fun nextPatchVersion(version: String) = Semver(version).nextPatch().toString()
}
