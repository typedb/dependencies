/*
 *  Copyright (C) 2022 Vaticle
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */

package com.vaticle.dependencies.tool.cargo

import com.electronwill.nightconfig.core.Config
import com.electronwill.nightconfig.toml.TomlWriter
import com.vaticle.bazel.distribution.common.Logging.LogLevel.DEBUG
import com.vaticle.bazel.distribution.common.Logging.LogLevel.ERROR
import com.vaticle.bazel.distribution.common.Logging.Logger
import com.vaticle.bazel.distribution.common.shell.Shell
import com.vaticle.bazel.distribution.common.util.FileUtil.listFilesRecursively
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.ASPECTS
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.BAZEL
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.BAZEL_BIN
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.BUILD
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.INFO
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.OUTPUT_BASE
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.OUTPUT_GROUPS_RUST_CARGO_SYNC_PROPERTIES
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.QUERY
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.RUST_CARGO_SYNC_PROPERTIES_ASPECT
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.RUST_TARGETS_DEPS_QUERY
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.RUST_TARGETS_QUERY
import com.vaticle.dependencies.tool.cargo.Syncer.ShellArgs.VATICLE_REPOSITORY_PREFIX
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.BUILD_DEPS
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.CONTAINS_GENERATED_SOURCES
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.DEPS_PREFIX
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.EDITION
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.ENTRY_POINT_PATH
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.FEATURES
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.LABEL
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.NAME
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.PATH
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.ROOT_PATH
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.TYPE
import com.vaticle.dependencies.tool.cargo.Syncer.WorkspaceSyncer.TargetProperties.Keys.VERSION


import picocli.CommandLine
import java.io.File
import java.io.FileInputStream
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import java.util.*
import java.util.concurrent.Callable
import kotlin.io.path.Path
import kotlin.system.exitProcess

fun main(args: Array<String>): Unit = exitProcess(CommandLine(Syncer()).execute(*args))

@CommandLine.Command(name = "sync", mixinStandardHelpOptions = true)
class Syncer : Callable<Unit> {

    @CommandLine.Option(names = ["--verbose", "-v"], required = false)
    private var verbose: Boolean = false

    private lateinit var logger: Logger
    private lateinit var shell: Shell
    private val workspaceDir = Path(System.getenv("BUILD_WORKSPACE_DIRECTORY"))
    private lateinit var bazelOutputBase: Path

    override fun call() {
        logger = Logger(logLevel = if (verbose) DEBUG else ERROR)
        shell = Shell(logger, verbose)
        bazelOutputBase = Path(shell.execute(listOf(BAZEL, INFO, OUTPUT_BASE), workspaceDir).outputString().trim())

        val rustTargets = rustTargets(shell, workspaceDir)
        validateTargets(rustTargets)
        loadRustToolchainAndExternalDeps(rustTargets)
        vaticleRustWorkspaces().forEach { WorkspaceSyncer(it, logger, shell, bazelOutputBase).sync() }
    }

    private fun validateTargets(targets: List<String>) {
        shell.execute(command = listOf(BAZEL, BUILD) + targets + "--build=false", baseDir = workspaceDir)
    }

    private fun loadRustToolchainAndExternalDeps(rustTargets: List<String>) {
        shell.execute(command = listOf(BAZEL, BUILD) + rustTargets + "--keep_going", baseDir = workspaceDir, throwOnError = false)
    }

    private fun vaticleRustWorkspaces(): List<Path> {
        // e.g: [/Users/root/workspace/typedb-client-rust, /private/var/_bazel_root_/123abc/external/vaticle_typedb_protocol]
        return listOf(workspaceDir) + shell.execute(listOf(BAZEL, QUERY, RUST_TARGETS_DEPS_QUERY, "--output=package"), workspaceDir)
                .outputString().split(System.lineSeparator())
                .filter { it.startsWith(VATICLE_REPOSITORY_PREFIX) }
                .map { it.split("@")[1].split("//")[0] }
                .map { bazelOutputBase.resolve("external").resolve(it) }
    }

    companion object {
        private fun rustTargets(shell: Shell, workspace: Path): List<String> {
            return shell.execute(listOf(BAZEL, QUERY, RUST_TARGETS_QUERY), workspace)
                    .outputString().split(System.lineSeparator()).filter { it.isNotBlank() }
        }
    }

    private class WorkspaceSyncer(private val workspace: Path, private var logger: Logger, private var shell: Shell, var bazelOutputBase: Path) {

        private val bazelBin = workspace.resolve(BAZEL_BIN).toRealPath().toFile()

        fun sync() {
            logger.debug { "Syncing $workspace" }
            cleanupOldSyncProperties()
            runSyncPropertiesAspect()
            generateManifests()
            logger.debug { "Sync completed in $workspace" }
        }

        private fun cleanupOldSyncProperties() {
            logger.debug { "Cleaning up old cargo sync properties under $workspace" }
            val bazelBin = File(shell.execute(listOf(BAZEL, INFO, BAZEL_BIN), workspace).outputString().trim())
            bazelBin.listFilesRecursively().filter { it.name.endsWith(Paths.MANIFEST_SYNC_PROPERTIES_SUFFIX) }.forEach { it.delete() }
        }

        private fun runSyncPropertiesAspect() {
            val rustTargets = rustTargets(shell, workspace)
            shell.execute(
                    listOf(BAZEL, BUILD) + rustTargets + listOf(ASPECTS, RUST_CARGO_SYNC_PROPERTIES_ASPECT, OUTPUT_GROUPS_RUST_CARGO_SYNC_PROPERTIES),
                    workspace
            )
        }

        fun generateManifests() {
            val manifests = loadSyncProperties()
                    .filter { shouldGenerateManifest(it) }
                    .map { ManifestGenerator(it).generateManifest() }
            println(manifests.joinToString(System.lineSeparator()))
        }

        private fun loadSyncProperties(): List<TargetProperties> {
            return findSyncPropertiesFiles()
                    .map { TargetProperties.fromPropertiesFile(Path(it.path)) }
                    .apply { attachTestAndBuildProperties(this) }
        }

        private fun findSyncPropertiesFiles(): List<File> {
            val bazelBinContents = bazelBin.listFiles() ?: throw IllegalStateException()
            val filesToCheck = bazelBinContents.filter { it.isFile } + bazelBinContents
                    .filter { it.isDirectory && it.name != Paths.EXTERNAL }.flatMap { it.listFilesRecursively() }
            return filesToCheck.filter { it.name.endsWith(Paths.MANIFEST_SYNC_PROPERTIES_SUFFIX) }
        }

        private fun attachTestAndBuildProperties(properties: Collection<TargetProperties>) {
            val (testProperties, nonTestProperties) = properties.partition { it.type == TargetProperties.Type.TEST }
                    .let { it.first to it.second.associateBy { properties -> properties.name } }
            testProperties.forEach { tp ->
                tp.deps.filter { it.name in nonTestProperties }.forEach { nonTestProperties[it.name]!!.tests += tp }
            }
            val (buildProperties, nonBuildProperties) = properties.partition { it.type == TargetProperties.Type.BUILD }
                    .let { it.first.associateBy { properties -> properties.name } to it.second }
            nonBuildProperties.forEach { nbp ->
                nbp.buildDeps.forEach { buildProperties["${it}_"]?.let { buildProperties -> nbp.buildScripts += buildProperties } }
            }
        }

        private fun shouldGenerateManifest(properties: TargetProperties): Boolean {
            return properties.type in listOf(TargetProperties.Type.LIB, TargetProperties.Type.BIN)
        }

        private inner class ManifestGenerator(private val properties: TargetProperties) {
            fun generateManifest(): File {
                if (properties.containsGeneratedSources) buildTarget()
                val outputPath = manifestOutputPath()
                Files.newOutputStream(outputPath).use { it.write(manifestContent().toByteArray(StandardCharsets.UTF_8)) }
                return outputPath.toFile()
            }

            private fun buildTarget() {
                shell.execute(listOf(BAZEL, ShellArgs.BUILD, properties.label), baseDir = workspace)
            }

            private fun manifestOutputPath(): Path {
                val projectRelativePath = bazelBin.toPath().relativize(properties.path.parent)
                return workspace.resolve(projectRelativePath.toString()).resolve(Paths.CARGO_TOML)
            }

            private fun manifestContent(): String {
                val cargoToml = Config.inMemory()

                cargoToml.createSubConfig().apply {
                    cargoToml.set<Config>("package", this)
                    set<String>("name", properties.name)
                    set<String>("edition", properties.edition)
                    set<String>("version", properties.version)
                }

                cargoToml.createEntryPointSubConfig()

                cargoToml.createSubConfig().apply {
                    cargoToml.set<Config>("dependencies", this)
                    properties.deps.forEach { set<Config>(it.name, it.toToml(bazelOutputBase.toFile())) }
                }

                cargoToml.addDevAndBuildDependencies()

                return GENERATED_FILE_NOTICE + TomlWriter().writeToString(cargoToml.unmodifiable())
            }

            private fun Config.createEntryPointSubConfig() {
                val entryPointPath = if (properties.containsGeneratedSources) {
                    bazelBin.resolve(properties.entryPointPath.toString()).toString()
                } else properties.rootPath!!.relativize(properties.entryPointPath!!).toString()

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

                    TargetProperties.Type.TEST, TargetProperties.Type.BUILD -> throw IllegalStateException("${Paths.CARGO_TOML} should not be generated for sync properties of type ${properties.type}")
                }
            }

            private fun Config.addDevAndBuildDependencies() {
                if (properties.tests.isNotEmpty()) {
                    createSubConfig().apply {
                        this@addDevAndBuildDependencies.set<Config>("dev-dependencies", this)
                        properties.tests.flatMap { it.deps }
                                .distinctBy { it.name }
                                .filter { it.name != properties.name }
                                .forEach { set<Config>(it.name, it.toToml(bazelOutputBase.toFile())) }
                    }
                }

                if (properties.buildScripts.isNotEmpty()) {
                    createSubConfig().apply {
                        this@addDevAndBuildDependencies.set<Config>("build-dependencies", this)
                        properties.buildScripts.flatMap { it.deps }
                                .distinctBy { it.name }
                                .filter { it.name != properties.name }
                                .forEach { set<Config>(it.name, it.toToml(bazelOutputBase.toFile())) }
                    }
                }
            }
        }

        class TargetProperties(
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
                val tests: MutableCollection<TargetProperties>,
                val buildScripts: MutableCollection<TargetProperties>,
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
                            set<String>("path", path.replace(Paths.EXTERNAL_PLACEHOLDER, bazelOutputBase.resolve(Paths.EXTERNAL).absolutePath))
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
                fun fromPropertiesFile(path: Path): TargetProperties {
                    val props = Properties().apply { load(FileInputStream(path.toString())) }
                    try {
                        return TargetProperties(
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
                        throw IllegalStateException("Failed to parse Manifest Sync properties file at $path", e)
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
            const val MANIFEST_SYNC_PROPERTIES_SUFFIX = ".cargo-sync.properties"
        }

        companion object {
            const val GENERATED_FILE_NOTICE =
"""
# Generated by Vaticle Cargo sync tool.
# Do not commit or modify this file.

"""
        }
    }

    private object ShellArgs {
        const val ASPECTS = "--aspects"
        const val BAZEL = "bazel"
        const val BAZEL_BIN = "bazel-bin"
        const val BUILD = "build"
        const val INFO = "info"
        const val OUTPUT_BASE = "output_base"
        const val OUTPUT_GROUPS_RUST_CARGO_SYNC_PROPERTIES = "--output_groups=rust-cargo-sync-properties"
        const val QUERY = "query"
        const val RUST_CARGO_SYNC_PROPERTIES_ASPECT = "@vaticle_dependencies//tool/cargo:sync_properties_aspect.bzl%rust_cargo_sync_properties_aspect"
        const val RUST_TARGETS_DEPS_QUERY = "kind(rust_*, deps(//...))"
        const val RUST_TARGETS_QUERY = "kind(rust_*, //...)"
        const val VATICLE_REPOSITORY_PREFIX = "@vaticle_"
    }
}
