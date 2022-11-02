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
import com.vaticle.dependencies.ide.rust.SyncInfo.Type.BIN
import com.vaticle.dependencies.ide.rust.SyncInfo.Type.BUILD
import com.vaticle.dependencies.ide.rust.SyncInfo.Type.LIB
import com.vaticle.dependencies.ide.rust.SyncInfo.Type.TEST
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.BAZEL_BIN
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.CARGO_TOML
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.EXTERNAL
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.Paths.IDE_SYNC_PROPERTIES
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.ShellArgs.BAZEL
import com.vaticle.dependencies.ide.rust.CargoManifestGenerator.ShellArgs.INFO
import java.io.File
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Path
import kotlin.io.path.Path

class CargoManifestGenerator(private val workspaceRoot: File, shell: Shell) {

    private val bazelOutputBasePath = File(
        shell.execute(listOf(BAZEL, INFO, "output_base"), workspaceRoot.toPath()).outputString().trim()
    )
    private val bazelBinPath = workspaceRoot.resolve(BAZEL_BIN).toPath().toRealPath().toFile()

    fun generateManifests() {
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

    private fun loadSyncInfos(): List<SyncInfo> {
        return findSyncInfoFiles()
            .map { SyncInfo.fromPropertiesFile(Path(it.path)) }
            .apply { attachTestAndBuildInfos(this) }
    }

    private fun findSyncInfoFiles(): List<File> {
        val bazelBinContents = bazelBinPath.listFiles() ?: throw IllegalStateException()
        val filesToCheck = bazelBinContents.filter { it.isFile } + bazelBinContents
            .filter { it.isDirectory && it.name != EXTERNAL }.flatMap { it.listFilesRecursively() }
        return filesToCheck.filter { it.name.endsWith(IDE_SYNC_PROPERTIES) }
    }

    private fun attachTestAndBuildInfos(syncInfos: Collection<SyncInfo>) {
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

    private fun shouldGenerateManifest(info: SyncInfo): Boolean {
        return info.type in listOf(LIB, BIN)
    }

    private fun generateManifest(info: SyncInfo): String {
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

        cargoToml.addDevAndBuildDependencies(info)

        return GENERATED_FILE_NOTICE + TomlWriter().writeToString(cargoToml.unmodifiable())
    }

    private fun Config.createEntryPointSubConfig(info: SyncInfo) {
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
            TEST, BUILD -> throw IllegalStateException("$CARGO_TOML should not be generated for IDE sync info of type ${info.type}")
        }
    }

    private fun Config.addDevAndBuildDependencies(info: SyncInfo) {
        if (info.tests.isNotEmpty()) {
            createSubConfig().apply {
                this@addDevAndBuildDependencies.set<Config>("dev-dependencies", this)
                info.tests.flatMap { it.deps }
                    .distinctBy { it.name }
                    .filter { it.name != info.name }
                    .forEach { set<Config>(it.name, it.toToml(bazelOutputBasePath)) }
            }
        }

        if (info.buildScripts.isNotEmpty()) {
            createSubConfig().apply {
                this@addDevAndBuildDependencies.set<Config>("build-dependencies", this)
                info.buildScripts.flatMap { it.deps }
                    .distinctBy { it.name }
                    .filter { it.name != info.name }
                    .forEach { set<Config>(it.name, it.toToml(bazelOutputBasePath)) }
            }
        }
    }

    private fun manifestOutputPath(info: SyncInfo): Path {
        val projectRelativePath = bazelBinPath.toPath().relativize(info.path.parent)
        return workspaceRoot.resolve(projectRelativePath.toString()).resolve(CARGO_TOML).toPath()
    }

    private object Paths {
        const val BAZEL_BIN = "bazel-bin"
        const val CARGO_TOML = "Cargo.toml"
        const val EXTERNAL = "external"
        const val IDE_SYNC_PROPERTIES = "ide-sync.properties"
    }

    private object ShellArgs {
        const val BAZEL = "bazel"
        const val INFO = "info"
    }

    companion object {
        const val GENERATED_FILE_NOTICE =
"""
# Generated by Vaticle Rust IDE sync tool.
# Do not commit or modify this file.

"""
    }
}
