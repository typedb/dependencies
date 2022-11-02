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

import com.vaticle.bazel.distribution.common.Logging.LogLevel.DEBUG
import com.vaticle.bazel.distribution.common.Logging.LogLevel.ERROR
import com.vaticle.bazel.distribution.common.Logging.Logger
import com.vaticle.bazel.distribution.common.shell.Shell
import com.vaticle.bazel.distribution.common.util.FileUtil.listFilesRecursively
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.ASPECTS
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.BAZEL
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.BAZEL_BIN
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.BUILD
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.INFO
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.OUTPUT_BASE
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.OUTPUT_GROUPS_RUST_IDE_SYNC
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.QUERY
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.RUST_IDE_SYNC_ASPECT
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.RUST_TARGETS_DEPS_QUERY
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.RUST_TARGETS_QUERY
import com.vaticle.dependencies.ide.rust.SyncRunner.ShellArgs.VATICLE_REPOSITORY_PREFIX
import picocli.CommandLine
import java.io.File
import java.nio.file.Path
import java.util.concurrent.Callable
import kotlin.io.path.Path
import kotlin.system.exitProcess

fun main(args: Array<String>): Unit = exitProcess(CommandLine(SyncRunner()).execute(*args))

@CommandLine.Command(name = "sync", mixinStandardHelpOptions = true)
class SyncRunner : Callable<Unit> {

    @CommandLine.Option(names = ["--verbose", "-v"], required = false)
    private var verbose: Boolean = false

    private lateinit var logger: Logger
    private lateinit var shell: Shell
    private val buildWorkspaceDir = Path(System.getenv("BUILD_WORKSPACE_DIRECTORY"))
    private lateinit var bazelOutputBase: Path

    override fun call() {
        logger = Logger(logLevel = if (verbose) DEBUG else ERROR)
        shell = Shell(logger, verbose)
        bazelOutputBase = Path(shell.execute(listOf(BAZEL, INFO, OUTPUT_BASE), buildWorkspaceDir).outputString().trim())
        val rustTargets = rustTargets(buildWorkspaceDir)
        validateBuildWorkspace(rustTargets)
        loadRustToolchainAndExternalDeps(rustTargets)
        vaticleRustRepositories().forEach { sync(it) }
    }

    private fun validateBuildWorkspace(rustTargets: List<String>) {
        shell.execute(command = listOf(BAZEL, BUILD) + rustTargets + "--build=false", baseDir = buildWorkspaceDir)
    }

    private fun loadRustToolchainAndExternalDeps(rustTargets: List<String>) {
        shell.execute(command = listOf(BAZEL, BUILD) + rustTargets, baseDir = buildWorkspaceDir, throwOnError = false)
    }

    private fun vaticleRustRepositories(): List<Path> {
        // e.g: [/Users/root/workspace/typedb-client-rust, /private/var/_bazel_root_/123abc/external/vaticle_typedb_protocol]
        return listOf(buildWorkspaceDir) + shell.execute(listOf(BAZEL, QUERY, RUST_TARGETS_DEPS_QUERY, "--output=package"), buildWorkspaceDir)
            .outputString().split("\n")
            .filter { it.startsWith(VATICLE_REPOSITORY_PREFIX) }
            .map { it.split("@")[1].split("//")[0] }
            .map { bazelOutputBase.resolve("external").resolve(it) }
    }

    private fun sync(repository: Path) {
        logger.debug { "Syncing $repository" }
        cleanupOldSyncInfo(repository)
        runSyncInfoAspect(repository)
        CargoManifestGenerator(repository.toFile(), shell).generateManifests()
        logger.debug { "Sync completed in $repository" }
    }

    private fun cleanupOldSyncInfo(repository: Path) {
        logger.debug { "Cleaning up old sync info under $repository" }
        val bazelBin = File(shell.execute(listOf(BAZEL, INFO, BAZEL_BIN), repository).outputString().trim())
        bazelBin.listFilesRecursively().filter { it.name.endsWith(".ide-sync.properties") }.forEach { it.delete() }
    }

    private fun runSyncInfoAspect(repository: Path) {
        val rustTargets = rustTargets(repository)
        shell.execute(
            listOf(BAZEL, BUILD) + rustTargets + listOf(ASPECTS, RUST_IDE_SYNC_ASPECT, OUTPUT_GROUPS_RUST_IDE_SYNC),
            repository)
    }

    private fun rustTargets(repository: Path): List<String> {
        return shell.execute(listOf(BAZEL, QUERY, RUST_TARGETS_QUERY), repository)
            .outputString().split("\n").filter { it.isNotBlank() }
    }

    private object ShellArgs {
        const val ASPECTS = "--aspects"
        const val BAZEL = "bazel"
        const val BAZEL_BIN = "bazel-bin"
        const val BUILD = "build"
        const val INFO = "info"
        const val OUTPUT_BASE = "output_base"
        const val OUTPUT_GROUPS_RUST_IDE_SYNC = "--output_groups=rust-ide-sync"
        const val QUERY = "query"
        const val RUST_IDE_SYNC_ASPECT = "@vaticle_dependencies//ide/rust:sync_aspect.bzl%rust_ide_sync_aspect"
        const val RUST_TARGETS_DEPS_QUERY = "kind(rust_*, deps(//...))"
        const val RUST_TARGETS_QUERY = "kind(rust_*, //...)"
        const val VATICLE_REPOSITORY_PREFIX = "@vaticle_"
    }
}
