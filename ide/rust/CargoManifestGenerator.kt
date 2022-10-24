/*
 * Copyright (C) 2022 Vaticle
 *
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package com.vaticle.dependencies.ide.rust

import com.electronwill.nightconfig.core.Config
import com.electronwill.nightconfig.toml.TomlWriter
import com.vaticle.bazel.distribution.common.util.FileUtil.listFilesRecursively
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.DEPS_PREFIX
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.EDITION
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.ENTRY_POINT_PATH
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.FEATURES
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.NAME
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.PATH
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.ROOT_PATH
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.SOURCES_ARE_GENERATED
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.TYPE
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Keys.VERSION
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Type.BIN
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Type.LIB
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.IDESyncInfo.Type.TEST
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.BAZEL_BIN
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.CARGO_TOML
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.EXTERNAL
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.EXTERNAL_PLACEHOLDER
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.IDE_SYNC_PROPERTIES
import picocli.CommandLine
import picocli.CommandLine.Command
import picocli.CommandLine.Option
import java.io.File
import java.io.FileInputStream
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.util.Properties
import java.util.concurrent.Callable
import kotlin.io.path.Path
import kotlin.system.exitProcess

fun main(args: Array<String>): Unit = exitProcess(CommandLine(CargoManifestGenerator()).execute(*args))

@Command(name = "cargo-manifest-generator", mixinStandardHelpOptions = true)
class CargoManifestGenerator : Callable<Unit> {

    @Option(names = ["--workspace_root"], required = true)
    lateinit var workspaceRoot: File

    @Option(names = ["--bazel_output_base"], required = true)
    lateinit var bazelOutputBasePath: File

    private lateinit var bazelBinPath: File

    override fun call() {
        locateBazelBin()
        generateManifests()
    }

    private fun locateBazelBin() {
        bazelBinPath = workspaceRoot.resolve(BAZEL_BIN).toPath().toRealPath().toFile()
    }

    private fun generateManifests() {
        val syncInfos = loadSyncInfos()
        val outputPaths = mutableListOf<Path>()
        syncInfos.filter { shouldGenerateManifest(it) }.forEach { info ->
            val cargoToml = generateManifest(info)
            val outputPath = manifestOutputPath(info)
            Files.newOutputStream(outputPath).use { it.write(cargoToml.toByteArray(StandardCharsets.UTF_8)) }
            outputPaths.add(outputPath)
        }
        println(outputPaths.joinToString("\n"))
    }

    private fun loadSyncInfos(): List<IDESyncInfo> {
        return findSyncInfoFiles()
            .map { IDESyncInfo.fromPropertiesFile(Path(it.path)) }
            .apply { attachTestInfos(this) }
    }

    private fun findSyncInfoFiles(): List<File> {
        val bazelBinContents = bazelBinPath.listFiles() ?: throw IllegalStateException()
        val filesToCheck = bazelBinContents.filter { it.isFile } + bazelBinContents
            .filter { it.isDirectory && it.name != EXTERNAL }.flatMap { it.listFilesRecursively() }
        return filesToCheck.filter { it.name.endsWith(IDE_SYNC_PROPERTIES) }
    }

    private fun attachTestInfos(syncInfos: Collection<IDESyncInfo>) {
        val (testInfos, nonTestInfos) = syncInfos.partition { it.type == TEST }
            .let { it.first to it.second.associateBy { info -> info.name } }
        testInfos.forEach { testInfo ->
            testInfo.deps.filter { it.name in nonTestInfos }.forEach { nonTestInfos[it.name]!!.tests += testInfo }
        }
    }

    private fun shouldGenerateManifest(info: IDESyncInfo): Boolean {
        return info.type in listOf(LIB, BIN)
    }

    private fun generateManifest(info: IDESyncInfo): String {
        val cargoToml = Config.inMemory()

        cargoToml.createSubConfig().apply {
            cargoToml.set<Config>("package", this)
            set<String>("name", info.name)
            set<String>("edition", info.edition)
            set<String>("version", info.version)
        }

        cargoToml.createEntryPointSubConfig(info)

        cargoToml.createSubConfig().apply {
            cargoToml.set<Config>("dependencies", this)
            info.deps.forEach { set<Config>(it.name, it.toToml(bazelOutputBasePath)) }
        }

        if (info.tests.isNotEmpty()) {
            cargoToml.createSubConfig().apply {
                cargoToml.set<Config>("dev-dependencies", this)
                info.tests.flatMap { it.deps }
                    .distinctBy { it.name }
                    .filter { it.name != info.name }
                    .forEach { set<Config>(it.name, it.toToml(bazelOutputBasePath)) }
            }
        }

        return GENERATED_FILE_NOTICE + TomlWriter().writeToString(cargoToml.unmodifiable())
    }

    private fun Config.createEntryPointSubConfig(info: IDESyncInfo) {
        val entryPointPath = if (info.sourcesAreGenerated) {
            bazelBinPath.resolve(info.entryPointPath.toString()).toString()
        } else info.rootPath!!.relativize(info.entryPointPath!!).toString()

        when (info.type) {
            LIB -> {
                createSubConfig().apply {
                    this@createEntryPointSubConfig.set<Config>("lib", this)
                    set<String>("path", entryPointPath)
                }
            }
            BIN -> {
                createSubConfig().apply {
                    this@createEntryPointSubConfig.set<List<Config>>("bin", listOf(this))
                    val binPathString = info.entryPointPath.toString()
                    set<String>("name", binPathString.substring(0, binPathString.length - ".rs".length))
                    set<String>("path", entryPointPath)
                }
            }
            TEST -> throw IllegalStateException("$CARGO_TOML should not be generated for IDE sync info of type TEST")
        }
    }

    private fun manifestOutputPath(info: IDESyncInfo): Path {
        val projectRelativePath = bazelBinPath.toPath().relativize(info.path.parent)
        return workspaceRoot.resolve(projectRelativePath.toString()).resolve(CARGO_TOML).toPath()
    }

    data class IDESyncInfo(
        val path: Path,
        val name: String,
        val type: Type,
        val version: String,
        val edition: String,
        val deps: Collection<Dependency>,
        val rootPath: Path?,
        val entryPointPath: Path?,
        val sourcesAreGenerated: Boolean,
        val tests: MutableCollection<IDESyncInfo>
    ) {
        sealed class Dependency(open val name: String) {
            abstract fun toToml(bazelOutputBasePath: File): Config

            data class Crate(override val name: String, val version: String, val features: List<String>) : Dependency(name) {
                override fun toToml(bazelOutputBasePath: File): Config {
                    return Config.inMemory().apply {
                        set<String>("version", version)
                        set<List<String>>("features", features)
                    }
                }
            }

            data class Path(override val name: String, val path: String) : Dependency(name) {
                override fun toToml(bazelOutputBasePath: File): Config {
                    return Config.inMemory().apply {
                        set<String>("path", path.replace(EXTERNAL_PLACEHOLDER, bazelOutputBasePath.resolve(EXTERNAL).absolutePath))
                    }
                }
            }

            companion object {
                fun of(rawKey: String, rawValue: String): Dependency {
                    val name = rawKey.split(".", limit = 2)[1]
                    val rawValueProps = rawValue.split(";")
                        .associate { it.split("=", limit = 2).let { parts -> parts[0] to parts[1] } }
                    return if (VERSION in rawValueProps) {
                        Crate(
                            name = name,
                            version = rawValueProps[VERSION]!!,
                            features = rawValueProps[FEATURES]?.split(",") ?: emptyList()
                        )
                    } else {
                        Path(name = name, path = rawValueProps[PATH]!!)
                    }
                }
            }
        }

        enum class Type {
            LIB,
            BIN,
            TEST;

            companion object {
                fun of(value: String): Type {
                    return when (value) {
                        "lib" -> LIB
                        "bin" -> BIN
                        "test" -> TEST
                        else -> throw IllegalArgumentException()
                    }
                }
            }
        }

        companion object {
            fun fromPropertiesFile(path: Path): IDESyncInfo {
                val props = Properties().apply { load(FileInputStream(path.toString())) }
                try {
                    return IDESyncInfo(
                        path = path,
                        name = props.getProperty(NAME),
                        type = Type.of(props.getProperty(TYPE)),
                        version = props.getProperty(VERSION),
                        edition = props.getProperty(EDITION),
                        deps = parseDependencies(extractDependencyEntries(props)),
                        rootPath = props.getProperty(ROOT_PATH)?.let { Path(it) },
                        entryPointPath = props.getProperty(ENTRY_POINT_PATH)?.let { Path(it) },
                        sourcesAreGenerated = props.getProperty(SOURCES_ARE_GENERATED).toBoolean(),
                        tests = mutableListOf()
                    )
                } catch (e: Exception) {
                    throw IllegalStateException("Failed to parse IDE Sync properties file at $path", e)
                }
            }

            private fun extractDependencyEntries(props: Properties): Map<String, String> {
                return props.entries
                    .map { it.key.toString() to it.value.toString() }
                    .filter { it.first.startsWith("$DEPS_PREFIX.") }
                    .toMap()
            }

            private fun parseDependencies(raw: Map<String, String>): Collection<Dependency> {
                return raw.map { Dependency.of(it.key, it.value) }
            }
        }

        private object Keys {
            const val DEPS_PREFIX = "deps"
            const val EDITION = "edition"
            const val ENTRY_POINT_PATH = "entry.point.path"
            const val FEATURES = "features"
            const val NAME = "name"
            const val PATH = "path"
            const val ROOT_PATH = "root.path"
            const val TYPE = "type"
            const val SOURCES_ARE_GENERATED = "sources.are.generated"
            const val VERSION = "version"
        }
    }

    private object Paths {
        const val BAZEL_BIN = "bazel-bin"
        const val CARGO_TOML = "Cargo.toml"
        const val EXTERNAL = "external"
        const val EXTERNAL_PLACEHOLDER = "{external}"
        const val IDE_SYNC_PROPERTIES = "ide-sync.properties"
    }

    companion object {
        const val GENERATED_FILE_NOTICE =
"""
# Generated by Vaticle Rust IDE sync tool.
# Do not commit or modify this file.

"""
    }
}
