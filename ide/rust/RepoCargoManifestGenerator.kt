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
import com.vaticle.bazel.distribution.common.shell.Shell
import com.vaticle.bazel.distribution.common.util.FileUtil.listFilesRecursively
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Type.BIN
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Type.BUILD
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Type.LIB
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Type.TEST
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.Paths.BAZEL_BIN
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.Paths.CARGO_TOML
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.Paths.EXTERNAL
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.Paths.EXTERNAL_PLACEHOLDER
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.Paths.IDE_SYNC_PROPERTIES
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.ShellArgs.BAZEL
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.BUILD_DEPS
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.DEPS_PREFIX
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.EDITION
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.ENTRY_POINT_PATH
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.FEATURES
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.NAME
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.PATH
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.ROOT_PATH
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.CONTAINS_GENERATED_SOURCES
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.LABEL
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.TYPE
import com.vaticle.dependencies.ide.rust.RepoCargoManifestGenerator.TargetSyncInfo.Keys.VERSION
import java.io.File
import java.io.FileInputStream
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.util.Properties
import kotlin.io.path.Path

class RepoCargoManifestGenerator(private val repository: File, private val bazelOutputBase: File, private val shell: Shell) {

    private val bazelBin = repository.resolve(BAZEL_BIN).toPath().toRealPath().toFile()

    fun generateManifests() {
        val manifests = loadSyncInfos()
            .filter { shouldGenerateManifest(it) }
            .map { TargetCargoManifestGenerator(it).generateManifest() }
        println(manifests.joinToString("\n"))
    }

    private fun loadSyncInfos(): List<TargetSyncInfo> {
        return findSyncInfoFiles()
            .map { TargetSyncInfo.fromPropertiesFile(Path(it.path)) }
            .apply { attachTestAndBuildInfos(this) }
    }

    private fun findSyncInfoFiles(): List<File> {
        val bazelBinContents = bazelBin.listFiles() ?: throw IllegalStateException()
        val filesToCheck = bazelBinContents.filter { it.isFile } + bazelBinContents
            .filter { it.isDirectory && it.name != EXTERNAL }.flatMap { it.listFilesRecursively() }
        return filesToCheck.filter { it.name.endsWith(IDE_SYNC_PROPERTIES) }
    }

    private fun attachTestAndBuildInfos(syncInfos: Collection<TargetSyncInfo>) {
        val (testInfos, nonTestInfos) = syncInfos.partition { it.type == TEST }
            .let { it.first to it.second.associateBy { info -> info.name } }
        testInfos.forEach { testInfo ->
            testInfo.deps.filter { it.name in nonTestInfos }.forEach { nonTestInfos[it.name]!!.tests += testInfo }
        }
        val (buildInfos, nonBuildInfos) = syncInfos.partition { it.type == BUILD }
            .let { it.first.associateBy { info -> info.name } to it.second }
        nonBuildInfos.forEach { nonBuildInfo ->
            nonBuildInfo.buildDeps.forEach { buildInfos["${it}_"]?.let { buildInfo -> nonBuildInfo.buildScripts += buildInfo } }
        }
    }

    private fun shouldGenerateManifest(info: TargetSyncInfo): Boolean {
        return info.type in listOf(LIB, BIN)
    }

    private inner class TargetCargoManifestGenerator(private val info: TargetSyncInfo) {
        fun generateManifest(): File {
            if (info.containsGeneratedSources) buildTarget()
            val outputPath = manifestOutputPath()
            Files.newOutputStream(outputPath).use { it.write(manifestContent().toByteArray(StandardCharsets.UTF_8)) }
            return outputPath.toFile()
        }

        private fun buildTarget() {
            shell.execute(listOf(BAZEL, ShellArgs.BUILD, info.label), baseDir = repository.toPath())
        }

        private fun manifestOutputPath(): Path {
            val projectRelativePath = bazelBin.toPath().relativize(info.path.parent)
            return repository.resolve(projectRelativePath.toString()).resolve(CARGO_TOML).toPath()
        }

        private fun manifestContent(): String {
            val cargoToml = Config.inMemory()

            cargoToml.createSubConfig().apply {
                cargoToml.set<Config>("package", this)
                set<String>("name", info.name)
                set<String>("edition", info.edition)
                set<String>("version", info.version)
            }

            cargoToml.createEntryPointSubConfig()

            cargoToml.createSubConfig().apply {
                cargoToml.set<Config>("dependencies", this)
                info.deps.forEach { set<Config>(it.name, it.toToml(bazelOutputBase)) }
            }

            cargoToml.addDevAndBuildDependencies()

            return GENERATED_FILE_NOTICE + TomlWriter().writeToString(cargoToml.unmodifiable())
        }

        private fun Config.createEntryPointSubConfig() {
            val entryPointPath = if (info.containsGeneratedSources) {
                bazelBin.resolve(info.entryPointPath.toString()).toString()
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
                        set<String>("name", info.entryPointPath.toString().replace('/', '_').substringBeforeLast(".rs"))
                        set<String>("path", entryPointPath)
                    }
                }
                TEST, BUILD -> throw IllegalStateException("$CARGO_TOML should not be generated for sync info of type ${info.type}")
            }
        }

        private fun Config.addDevAndBuildDependencies() {
            if (info.tests.isNotEmpty()) {
                createSubConfig().apply {
                    this@addDevAndBuildDependencies.set<Config>("dev-dependencies", this)
                    info.tests.flatMap { it.deps }
                        .distinctBy { it.name }
                        .filter { it.name != info.name }
                        .forEach { set<Config>(it.name, it.toToml(bazelOutputBase)) }
                }
            }

            if (info.buildScripts.isNotEmpty()) {
                createSubConfig().apply {
                    this@addDevAndBuildDependencies.set<Config>("build-dependencies", this)
                    info.buildScripts.flatMap { it.deps }
                        .distinctBy { it.name }
                        .filter { it.name != info.name }
                        .forEach { set<Config>(it.name, it.toToml(bazelOutputBase)) }
                }
            }
        }
    }

    data class TargetSyncInfo(
        val path: Path,
        val name: String,
        val label: String,
        val type: Type,
        val version: String,
        val edition: String?,
        val deps: Collection<Dependency>,
        val buildDeps: Collection<String>,
        val rootPath: Path?,
        val entryPointPath: Path?,
        val containsGeneratedSources: Boolean,
        val tests: MutableCollection<TargetSyncInfo>,
        val buildScripts: MutableCollection<TargetSyncInfo>,
    ) {
        sealed class Dependency(open val name: String) {
            abstract fun toToml(bazelOutputBase: File): Config

            data class Crate(override val name: String, val version: String, val features: List<String>) : Dependency(name) {
                override fun toToml(bazelOutputBase: File): Config {
                    return Config.inMemory().apply {
                        set<String>("version", version)
                        set<List<String>>("features", features)
                    }
                }
            }

            data class Path(override val name: String, val path: String) : Dependency(name) {
                override fun toToml(bazelOutputBase: File): Config {
                    return Config.inMemory().apply {
                        set<String>("path", path.replace(EXTERNAL_PLACEHOLDER, bazelOutputBase.resolve(EXTERNAL).absolutePath))
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

        companion object {
            fun fromPropertiesFile(path: Path): TargetSyncInfo {
                val props = Properties().apply { load(FileInputStream(path.toString())) }
                try {
                    return TargetSyncInfo(
                        path = path,
                        name = props.getProperty(NAME),
                        label = props.getProperty(LABEL),
                        type = Type.of(props.getProperty(TYPE)),
                        version = props.getProperty(VERSION),
                        edition = props.getProperty(EDITION, "2021"),
                        deps = parseDependencies(extractDependencyEntries(props)),
                        buildDeps = props.getProperty(BUILD_DEPS, "").split(",").filter { it.isNotBlank() },
                        rootPath = props.getProperty(ROOT_PATH)?.let { Path(it) },
                        entryPointPath = props.getProperty(ENTRY_POINT_PATH)?.let { Path(it) },
                        containsGeneratedSources = props.getProperty(CONTAINS_GENERATED_SOURCES).toBoolean(),
                        tests = mutableListOf(),
                        buildScripts = mutableListOf(),
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
            const val BUILD_DEPS = "build.deps"
            const val DEPS_PREFIX = "deps"
            const val EDITION = "edition"
            const val ENTRY_POINT_PATH = "entry.point.path"
            const val FEATURES = "features"
            const val LABEL = "label"
            const val NAME = "name"
            const val PATH = "path"
            const val ROOT_PATH = "root.path"
            const val TYPE = "type"
            const val CONTAINS_GENERATED_SOURCES = "contains.generated.sources"
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

    private object ShellArgs {
        const val BAZEL = "bazel"
        const val BUILD = "build"
    }

    companion object {
        const val GENERATED_FILE_NOTICE =
"""
# Generated by Vaticle Rust IDE sync tool.
# Do not commit or modify this file.

"""
    }
}
