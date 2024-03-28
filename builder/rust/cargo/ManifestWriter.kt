/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package com.vaticle.dependencies.builder.rust.cargo

import com.electronwill.nightconfig.core.Config
import com.electronwill.nightconfig.toml.TomlWriter

import picocli.CommandLine
import java.io.FileInputStream
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.util.*
import java.util.concurrent.Callable
import kotlin.io.path.Path
import kotlin.system.exitProcess

fun main(args: Array<String>): Unit = exitProcess(CommandLine(ManifestWriter()).execute(*args))

@CommandLine.Command(name = "sync", mixinStandardHelpOptions = true)
class ManifestWriter : Callable<Unit> {

    @CommandLine.Option(names = ["--properties", "-p"], required = true)
    private lateinit var rootPropertiesFile: Path

    @CommandLine.Option(names = ["--output", "-o"], required = true)
    private lateinit var outputPath: Path

    @CommandLine.Parameters
    private var buildPropertiesFiles: List<Path> = listOf()

    private lateinit var properties: TargetProperties
    private lateinit var buildProperties: List<TargetProperties>

    override fun call() {
        buildProperties = buildPropertiesFiles.map { TargetProperties.fromPropertiesFile(it) }
        properties = TargetProperties.fromPropertiesFile(rootPropertiesFile)
        properties.attach(buildProperties)

        Files.newOutputStream(outputPath).write(manifestContent(properties).toByteArray(StandardCharsets.UTF_8))
    }

    private fun manifestContent(properties: TargetProperties): String {
        val cargoToml = Config.inMemory()

        cargoToml.createSubConfig().apply {
            cargoToml.set<Config>("package", this)
            set<String>("name", properties.name)
            set<String>("edition", properties.edition)
            set<String>("version", properties.version)
        }

        if (properties.type != TargetProperties.Type.TEST) cargoToml.createEntryPointSubConfig()

        cargoToml.createSubConfig().apply {
            cargoToml.set<Config>("dependencies", this)
            properties.deps.forEach { set<Config>(it.name, it.toToml()) }
        }

        cargoToml.addBuildDependencies()

        return GENERATED_FILE_NOTICE + TomlWriter().writeToString(cargoToml.unmodifiable())
    }

    private fun Config.createEntryPointSubConfig() {
        val entryPointPath = properties.entryPointPath.toString()

        when (properties.type) {
            TargetProperties.Type.LIB -> {
                createSubConfig().apply {
                    this@createEntryPointSubConfig.set<Config>("lib", this)
                    set<String>("path", entryPointPath)
                }
            }

            TargetProperties.Type.BIN -> {
                createSubConfig().apply {
                    this@createEntryPointSubConfig.set<List<Config>>("bin", listOf(this))
                    set<String>("name", properties.name)
                    set<String>("path", entryPointPath)
                }
            }

            TargetProperties.Type.TEST, TargetProperties.Type.BUILD -> throw IllegalStateException("Cargo manifest should not be generated for sync properties of type ${properties.type}")
        }
    }

    private fun Config.addBuildDependencies() {
        if (properties.buildScripts.isNotEmpty()) {
            createSubConfig().apply {
                this@addBuildDependencies.set<Config>("build-dependencies", this)
                properties.buildScripts.flatMap { it.deps }
                        .distinctBy { it.name }
                        .filter { it.name != properties.name }
                        .forEach { set<Config>(it.name, it.toToml()) }
            }
        }
    }

    companion object {
        const val GENERATED_FILE_NOTICE =
"""
# Generated by Vaticle Cargo sync tool.
# Do not commit or modify this file.

"""
    }

    class TargetProperties(
            val path: Path,
            val name: String,
            val type: Type,
            val version: String,
            val edition: String?,
            val entryPointPath: Path?,
            val deps: Collection<Dependency>,
            var buildScripts: Collection<TargetProperties>,
    ) {
        fun attach(properties: List<TargetProperties>) {
            buildScripts = properties
        }

        companion object {
            fun fromPropertiesFile(path: Path): TargetProperties {
                val props = Properties().apply { load(FileInputStream(path.toString())) }
                try {
                    return TargetProperties(
                            path = path,
                            name = props.getProperty(Keys.NAME),
                            type = Type.of(props.getProperty(Keys.TYPE)),
                            version = props.getProperty(Keys.VERSION),
                            edition = props.getProperty(Keys.EDITION, "2021"),
                            deps = parseDependencies(extractDependencyEntries(props)),
                            entryPointPath = props.getProperty(Keys.ENTRY_POINT_PATH)?.let { Path(it) },
                            buildScripts = listOf(),
                    )
                } catch (e: Exception) {
                    throw IllegalStateException("Failed to parse Manifest Sync properties file at $path", e)
                }
            }

            private fun extractDependencyEntries(props: Properties): Map<String, String> {
                return props.entries
                        .map { it.key.toString() to it.value.toString() }
                        .filter { it.first.startsWith("${Keys.DEPS_PREFIX}.") }
                        .toMap()
            }

            private fun parseDependencies(raw: Map<String, String>): Collection<Dependency> {
                return raw.map { Dependency.of(it.key, it.value) }
            }
        }

        enum class Type {
            LIB,
            BIN,
            TEST,
            BUILD;

            companion object {
                fun of(value: String): Type {
                    return when (value) {
                        "lib" -> LIB
                        "bin" -> BIN
                        "test" -> TEST
                        "build" -> BUILD
                        else -> throw IllegalArgumentException()
                    }
                }
            }
        }

        private object Keys {
            const val DEPS_PREFIX = "deps"
            const val EDITION = "edition"
            const val ENTRY_POINT_PATH = "entry.point.path"
            const val FEATURES = "features"
            const val NAME = "name"
            const val PATH = "path"
            const val TYPE = "type"
            const val VERSION = "version"
        }

        sealed class Dependency(open val name: String) {
            abstract fun toToml(): Config

            data class Crate(override val name: String, val version: String, val features: List<String>) : Dependency(name) {
                override fun toToml(): Config {
                    return Config.inMemory().apply {
                        set<String>("version", version)
                        set<List<String>>("features", features)
                    }
                }
            }

            data class Path(override val name: String, val path: String) : Dependency(name) {
                override fun toToml(): Config {
                    return Config.inMemory().apply {
                        set<String>("path", path)
                    }
                }
            }

            companion object {
                fun of(rawKey: String, rawValue: String): Dependency {
                    val name = rawKey.split(".", limit = 2)[1]
                    val rawValueProps = rawValue.split(";")
                            .associate { it.split("=", limit = 2).let { parts -> parts[0] to parts[1] } }
                    return if (Keys.VERSION in rawValueProps) {
                        Crate(
                                name = name,
                                version = rawValueProps[Keys.VERSION]!!,
                                features = rawValueProps[Keys.FEATURES]?.split(",") ?: emptyList()
                        )
                    } else {
                        Path(name = name, path = rawValueProps[Keys.PATH]!!)
                    }
                }
            }
        }
    }
}
