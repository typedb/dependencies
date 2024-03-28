/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
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
import com.vaticle.dependencies.tool.ide.RustManifestSyncer.WorkspaceSyncer.TargetProperties.Keys.LOCAL_PATH
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
import java.nio.file.StandardOpenOption
import java.util.Properties
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
        val canonicalExternalPathDeps: MutableMap<String, String> = mutableMapOf()

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
                    .toMutableList()

            // append Cargo Workspace to root Cargo Manifest, or create it if it does not exist
            val workspaceManifest = manifests.stream().filter { it.toPath().parent.equals(workspace) }
                    .findFirst()
            val cargoWorkspaceConfig = createCargoWorkspace(manifests);
            val cargoWorkspaceString = TomlWriter().writeToString(cargoWorkspaceConfig.unmodifiable())
            val rootTomlPath = workspace.resolve(CARGO_TOML);

            Files.newOutputStream(rootTomlPath, StandardOpenOption.APPEND, StandardOpenOption.CREATE).use {
                it.write(cargoWorkspaceString.toByteArray(StandardCharsets.UTF_8))
            }

            if (!workspaceManifest.isPresent) {
                manifests.add(rootTomlPath.toFile())
            }
            println(manifests.joinToString(System.lineSeparator()))
        }

        private fun createCargoWorkspace(manifests: List<File>): Config {
            val manifestPaths = manifests.map { workspace.relativize(it.toPath().parent).toString() }
                    .filter { it.isNotBlank() }
                    .distinct()
                    .toList()

            val cargoToml = Config.inMemory();
            val subConfig = cargoToml.createSubConfig()
            subConfig.set<List<String>>("members", manifestPaths)
            cargoToml.set<Config>("workspace", subConfig)
            return cargoToml
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
            val BENCHES_DIR = "benches" // we translate Bazel Tests in 'benches' into Cargo benchmarks
            val (testProperties, nonTestProperties) = properties.partition { it.type == TargetProperties.Type.TEST }
                    .let { it.first to it.second.associateBy { properties -> properties.name } }
            testProperties.forEach { tp ->
                // attach tests deps to the parent properties
                var path = tp.path.toPath()
                while (
                        path.parent != null && path.fileName != null &&
                        (!path.fileName.toString().equals(TESTS_DIR) && !path.fileName.toString().equals(BENCHES_DIR))
                ) {
                    path = path.parent
                }
                val isTest: Boolean
                if (path.fileName == null) {
                    logger.debug { "Could not find directory named '$TESTS_DIR' for test '${tp.name}', assuming unit test..." }
                    path = tp.path.toPath()
                    isTest = true
                } else if (path.fileName.toString().equals(TESTS_DIR)) {
                    isTest = true
                } else if (path.fileName.toString().equals(BENCHES_DIR)) {
                    isTest = false
                } else {
                    throw RuntimeException("Could not find directory named '$TESTS_DIR' or '$BENCHES_DIR' for Bazel test target '${tp.name}'.");
                }
                val parent = nonTestProperties.values.filter { it.path.parentFile.toPath().equals(path.parent) };
                if (parent.size != 1) {
                    throw RuntimeException("Found '${parent.size}' parents to attach test '${tp.name}' to.")
                }

                if (isTest) {
                    parent[0].tests += tp
                } else {
                    parent[0].benches += tp
                }
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
                Files.newOutputStream(outputPath).use {
                    it.write(manifestContent().toByteArray(StandardCharsets.UTF_8))
                }
                return outputPath.toFile()
            }

            private fun manifestOutputPath(bazelBin: File): Path {
                return workspace.resolve(bazelBin.toPath().relativize(Path(properties.path.parent)).resolve(CARGO_TOML))
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
                    properties.deps.forEach { set<Config>(it.name, it.toToml(properties.cargoWorkspaceDir, canonicalExternalPathDeps)) }
                }

                cargoToml.addDevAndBuildDependencies()
                cargoToml.addBenches()

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

            private fun Config.addDevAndBuildDependencies() {
                if (properties.tests.isNotEmpty() || properties.benches.isNotEmpty()) {
                    createSubConfig().apply {
                        this@addDevAndBuildDependencies.set<Config>("dev-dependencies", this)
                        arrayOf(properties.tests, properties.benches).flatMap { it }
                                .flatMap { it.deps.map { dep -> Pair(it.cargoWorkspaceDir, dep) } }
                                .distinctBy { (_, dep) -> dep.name }
                                .filter { (_, dep) -> (dep.name != properties.name) && properties.deps.none { existingDep -> dep.name == existingDep.name } }
                                .forEach { (cargoWorkspaceDir, dep) ->
                                    // WARN: this is a hack to replace 'local' repository paths that are relative to the test
                                    //       to make them relative to the parent Cargo Toml
                                    //       currently will only work for <package>/tests (ie. exactly one level of nesting)
                                    val toml = dep.toToml(cargoWorkspaceDir, canonicalExternalPathDeps);
                                    val path: String? = toml.get("path");
                                    if (path != null && path.startsWith("../..")) {
                                        toml.set<String>("path", path.replaceFirst("../..", ".."))
                                    }
                                    set<Config>(dep.name, toml)
                                }
                    }
                }

                if (properties.buildScripts.isNotEmpty()) {
                    createSubConfig().apply {
                        this@addDevAndBuildDependencies.set<Config>("build-dependencies", this)
                        properties.buildScripts
                                .flatMap { it.deps.map { dep -> Pair(it.cargoWorkspaceDir, dep) } }
                                .distinctBy { (_, dep) -> dep.name }
                                .filter { (_, dep) -> (dep.name != properties.name) }
                                .forEach { (cargoWorkspaceDir, dep) -> set<Config>(dep.name, dep.toToml(cargoWorkspaceDir, canonicalExternalPathDeps)) }
                    }
                }
            }

            private fun Config.addBenches() {
                if (properties.benches.isNotEmpty()) {
                    val mapped = properties.benches.map {
                        createSubConfig().apply {
                            this.set<String>("name", it.name);
                            this.set<String>("harness", false);
                        }
                    }
                    this.set<List<Config>>("bench", mapped)
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
                val benches: MutableCollection<TargetProperties>,
                val buildScripts: MutableCollection<TargetProperties>,
        ) {
            val cargoWorkspaceDir get() = path.parentFile.resolve(targetName + CARGO_WORKSPACE_SUFFIX)

            sealed class Dependency(open val name: String) {
                abstract fun toToml(cargoWorkspaceDir: File, canonicalExternalPathDeps: MutableMap<String, String>): Config

                data class Crate(override val name: String, val version: String, val features: List<String>) : Dependency(name) {
                    override fun toToml(cargoWorkspaceDir: File, canonicalExternalPathDeps: MutableMap<String, String>): Config {
                        return Config.inMemory().apply {
                            set<String>("version", version)
                            set<List<String>>("features", features)
                            set<Boolean>("default_features", false)
                        }
                    }
                }

                data class Local(override val name: String, val external_path: String?, val local_path: String?) : Dependency(name) {
                    override fun toToml(cargoWorkspaceDir: File, canonicalExternalPathDeps: MutableMap<String, String>): Config {
                        return Config.inMemory().apply {
                            if (external_path != null) {
                                set<String>("path",
                                    canonicalExternalPathDeps.computeIfAbsent(name) {
                                        external_path.replace(EXTERNAL_PLACEHOLDER, cargoWorkspaceDir.toString())
                                    }
                                )
                            } else if (local_path != null) {
                                set<String>("path", local_path)
                            } else {
                                throw IllegalStateException();
                            }
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
                        } else if (LOCAL_PATH in rawValueProps) {
                            Local(name = name, external_path = null, local_path = rawValueProps[LOCAL_PATH]!!)
                        } else {
                            Local(name = name, external_path = rawValueProps[PATH]!!, local_path = null)
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
                                benches = mutableListOf(),
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
                const val LOCAL_PATH = "localpath"
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
