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

package com.vaticle.dependencies.tool.ide

import com.electronwill.nightconfig.core.Config
import com.electronwill.nightconfig.toml.TomlWriter
import com.vaticle.bazel.distribution.common.Logging.LogLevel.DEBUG
import com.vaticle.bazel.distribution.common.Logging.LogLevel.ERROR
import com.vaticle.bazel.distribution.common.Logging.Logger
import com.vaticle.bazel.distribution.common.shell.Shell
import com.vaticle.bazel.distribution.common.util.FileUtil.listFilesRecursively
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.ShellArgs.ASPECTS
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.ShellArgs.BAZEL
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.ShellArgs.BAZEL_BIN
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.ShellArgs.BUILD
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.ShellArgs.INFO
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.ShellArgs.OUTPUT_GROUPS
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.ShellArgs.QUERY
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.ShellArgs.RUST_TARGETS_QUERY
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.Paths.CARGO_TOML
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.Paths.CARGO_WORKSPACE_SUFFIX
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.Paths.EXTERNAL_PLACEHOLDER
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.Paths.MANIFEST_PROPERTIES_SUFFIX
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.BUILD_DEPS
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.DEPS_PREFIX
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.EDITION
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.ENTRY_POINT_PATH
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.FEATURES
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.NAME
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.PATH
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.TARGET_NAME
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.TYPE
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.VERSION


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

fun main(args: Array<String>): Unit = exitProcess(CommandLine(RustManifestSyncer()).execute(*args))

@CommandLine.Command(name = "sync", mixinStandardHelpOptions = true)
class RustManifestSyncer : Callable<Unit> {

    @CommandLine.Option(names = ["--verbose", "-v"], required = false)
    private var verbose: Boolean = false

    private lateinit var logger: Logger
    private lateinit var shell: Shell
    private val workspaceDir = Path(System.getenv("BUILD_WORKSPACE_DIRECTORY"))

    override fun call() {
        logger = Logger(logLevel = if (verbose) DEBUG else ERROR)
        shell = Shell(logger, verbose)

        val rustTargets = rustTargets(shell, workspaceDir)
        validateTargets(rustTargets)
        loadRustToolchainAndExternalDeps(rustTargets)
        WorkspaceSyncer(workspaceDir, logger, shell).sync()
    }

    private fun validateTargets(targets: List<String>) {
        shell.execute(command = listOf(BAZEL, BUILD) + targets + "--build=false", baseDir = workspaceDir)
    }

    private fun loadRustToolchainAndExternalDeps(rustTargets: List<String>) {
        shell.execute(command = listOf(BAZEL, BUILD) + rustTargets + "--keep_going", baseDir = workspaceDir, throwOnError = false)
    }

    companion object {
        private fun rustTargets(shell: Shell, workspace: Path): List<String> {
            return shell.execute(listOf(BAZEL, QUERY, RUST_TARGETS_QUERY), workspace)
                    .outputString().split(System.lineSeparator()).filter { it.isNotBlank() }
        }
    }

    private class WorkspaceSyncer(private val workspace: Path, private var logger: Logger, private var shell: Shell) {

        fun sync() {
            logger.debug { "Syncing $workspace" }
            cleanupOldSyncProperties()
            runCargoProjectAspect()
            val bazelBin = workspace.resolve(BAZEL_BIN).toRealPath().toFile()
            generateManifests(bazelBin);
            logger.debug { "Sync completed in $workspace" }
        }

        private fun cleanupOldSyncProperties() {
            logger.debug { "Cleaning up old cargo sync properties under $workspace" }
            val bazelBin = File(shell.execute(listOf(BAZEL, INFO, BAZEL_BIN), workspace).outputString().trim())
            bazelBin.listFilesRecursively().filter { it.name.endsWith(MANIFEST_PROPERTIES_SUFFIX) }.forEach { it.delete() }
        }

        private fun runCargoProjectAspect() {
            val rustTargets = rustTargets(shell, workspace)
            shell.execute(listOf(BAZEL, BUILD) + rustTargets + listOf(ASPECTS, OUTPUT_GROUPS), workspace)
        }

        fun generateManifests(bazelBin: File) {
            val manifests = loadSyncProperties(bazelBin)
                    .filter { shouldGenerateManifest(it) }
                    .map { ManifestGenerator(it).generateManifest(bazelBin) }
            println(manifests.joinToString(System.lineSeparator()))
        }

        private fun loadSyncProperties(bazelBin: File): List<TargetProperties> {
            return findSyncPropertiesFiles(bazelBin)
                    .map { TargetProperties.fromPropertiesFile(it) }
                    .apply { attachTestAndBuildProperties(this) }
        }

        private fun findSyncPropertiesFiles(bazelBin: File): List<File> {
            val bazelBinContents = bazelBin.listFiles() ?: throw IllegalStateException()
            val filesToCheck = bazelBinContents.filter { it.isFile } + bazelBinContents
                    .filter { it.isDirectory && it.name != Paths.EXTERNAL }.flatMap { it.listFilesRecursively() }
            return filesToCheck.filter { it.name.endsWith(MANIFEST_PROPERTIES_SUFFIX) }
        }

        private fun attachTestAndBuildProperties(properties: Collection<TargetProperties>) {
            val TESTS_DIR = "tests"
            val (testProperties, nonTestProperties) = properties.partition { it.type == TargetProperties.Type.TEST }
                    .let { it.first to it.second.associateBy { properties -> properties.name } }
            testProperties.forEach { tp ->
                // attach tests deps to the parent properties
                var testsPath = tp.path.toPath();
                while (testsPath.parent != null && testsPath.fileName != null && !testsPath.fileName.toString().equals(TESTS_DIR)) {
                    testsPath = testsPath.parent
                }
                if (!testsPath.fileName.toString().equals(TESTS_DIR)) {
                    throw RuntimeException("Could not find directory named '$TESTS_DIR' for test '${tp.name}'.");
                }
                val parent = nonTestProperties.values.filter { it.path.parentFile.toPath().equals(testsPath.parent) };
                if (parent.size != 1) {
                    throw RuntimeException("Found '${parent.size}'parents to attach test '${tp.name}' to.")
                }
                parent[0].tests += tp
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
            fun generateManifest(bazelBin: File): File {
                val outputPath = manifestOutputPath(bazelBin)
                val cargoWorkspaceDir = properties.path.parentFile.resolve(properties.targetName + CARGO_WORKSPACE_SUFFIX)
                Files.newOutputStream(outputPath).use {
                    it.write(manifestContent(cargoWorkspaceDir).toByteArray(StandardCharsets.UTF_8))
                }
                return outputPath.toFile()
            }

            private fun manifestOutputPath(bazelBin: File): Path {
                return workspace.resolve(bazelBin.toPath().relativize(Path(properties.path.parent)).resolve(CARGO_TOML))
            }

            private fun manifestContent(cargoWorkspaceDir: File): String {
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
                    properties.deps.forEach { set<Config>(it.name, it.toToml(cargoWorkspaceDir)) }
                }

                cargoToml.addDevAndBuildDependencies(cargoWorkspaceDir)

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

                    TargetProperties.Type.TEST, TargetProperties.Type.BUILD -> throw IllegalStateException(
                        "$CARGO_TOML should not be generated for sync properties of type ${properties.type}"
                    )
                }
            }

            private fun Config.addDevAndBuildDependencies(cargoWorkspaceDir: File) {
                if (properties.tests.isNotEmpty()) {
                    createSubConfig().apply {
                        this@addDevAndBuildDependencies.set<Config>("dev-dependencies", this)
                        properties.tests.flatMap { it.deps }
                                .distinctBy { it.name }
                                .filter { it.name != properties.name }
                                .forEach { set<Config>(it.name, it.toToml(cargoWorkspaceDir)) }
                    }
                }

                if (properties.buildScripts.isNotEmpty()) {
                    createSubConfig().apply {
                        this@addDevAndBuildDependencies.set<Config>("build-dependencies", this)
                        properties.buildScripts.flatMap { it.deps }
                                .distinctBy { it.name }
                                .filter { it.name != properties.name }
                                .forEach { set<Config>(it.name, it.toToml(cargoWorkspaceDir)) }
                    }
                }
            }
        }

        data class TargetProperties(
                val path: File,
                val name: String,
                val targetName: String,
                val type: Type,
                val version: String,
                val edition: String?,
                val entryPointPath: Path?,
                val buildDeps: Collection<String>,
                val deps: Collection<Dependency>,
                val tests: MutableCollection<TargetProperties>,
                val buildScripts: MutableCollection<TargetProperties>,
        ) {
            sealed class Dependency(open val name: String) {
                abstract fun toToml(cargoWorkspaceDir: File): Config

                data class Crate(override val name: String, val version: String, val features: List<String>) : Dependency(name) {
                    override fun toToml(cargoWorkspaceDir: File): Config {
                        return Config.inMemory().apply {
                            set<String>("version", version)
                            set<List<String>>("features", features)
                            set<Boolean>("default_features", false)
                        }
                    }
                }

                data class Local(override val name: String, val path: String) : Dependency(name) {
                    override fun toToml(cargoWorkspaceDir: File): Config {
                        return Config.inMemory().apply {
                            set<String>("path", path.replace(EXTERNAL_PLACEHOLDER, cargoWorkspaceDir.toString()))
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
                                    features = rawValueProps[FEATURES]?.split(",") ?: emptyList(),
                            )
                        } else {
                            Local(name = name, path = rawValueProps[PATH]!!)
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
                fun fromPropertiesFile(path: File): TargetProperties {
                    val props = Properties().apply { load(FileInputStream(path.toString())) }
                    try {
                        return TargetProperties(
                                path = path,
                                name = props.getProperty(NAME),
                                targetName = props.getProperty(TARGET_NAME),
                                type = Type.of(props.getProperty(TYPE)),
                                version = props.getProperty(VERSION),
                                edition = props.getProperty(EDITION, "2021"),
                                deps = parseDependencies(extractDependencyEntries(props)),
                                buildDeps = props.getProperty(BUILD_DEPS, "").split(",").filter { it.isNotBlank() },
                                entryPointPath = props.getProperty(ENTRY_POINT_PATH)?.let { Path(it) },
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
                const val TARGET_NAME = "target.name"
                const val NAME = "name"
                const val PATH = "path"
                const val TYPE = "type"
                const val VERSION = "version"
            }
        }

        private object Paths {
            const val CARGO_TOML = "Cargo.toml"
            const val EXTERNAL = "external"
            const val EXTERNAL_PLACEHOLDER = ".."
            const val MANIFEST_PROPERTIES_SUFFIX = ".cargo.properties"
            const val CARGO_WORKSPACE_SUFFIX = "-cargo-workspace"
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
        const val ASPECTS = "--aspects=@vaticle_dependencies//builder/rust/cargo:project_aspect.bzl%rust_cargo_project_aspect"
        const val BAZEL = "bazel"
        const val BAZEL_BIN = "bazel-bin"
        const val BUILD = "build"
        const val INFO = "info"
        const val OUTPUT_GROUPS = "--output_groups=rust_cargo_project"
        const val QUERY = "query"
        const val RUST_TARGETS_QUERY = "kind(rust_*, //...)"
    }
}
