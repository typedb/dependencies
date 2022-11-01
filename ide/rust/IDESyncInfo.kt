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
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.BUILD_DEPS
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.DEPS_PREFIX
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.EDITION
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.ENTRY_POINT_PATH
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.FEATURES
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.NAME
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.PATH
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.ROOT_PATH
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.TYPE
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.SOURCES_ARE_GENERATED
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Keys.VERSION
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Paths.EXTERNAL
import com.vaticle.dependencies.ide.rust.IDESyncInfo.Paths.EXTERNAL_PLACEHOLDER
import java.io.File
import java.io.FileInputStream
import java.nio.file.Path
import java.util.Properties
import kotlin.io.path.Path

data class IDESyncInfo(
    val path: Path,
    val name: String,
    val type: Type,
    val version: String,
    val edition: String?,
    val deps: Collection<Dependency>,
    val buildDeps: Collection<String>,
    val rootPath: Path?,
    val entryPointPath: Path?,
    val sourcesAreGenerated: Boolean,
    val tests: MutableCollection<IDESyncInfo>,
    val buildScripts: MutableCollection<IDESyncInfo>,
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
        fun fromPropertiesFile(path: Path): IDESyncInfo {
            val props = Properties().apply { load(FileInputStream(path.toString())) }
            try {
                return IDESyncInfo(
                    path = path,
                    name = props.getProperty(NAME),
                    type = Type.of(props.getProperty(TYPE)),
                    version = props.getProperty(VERSION),
                    edition = props.getProperty(EDITION, "2021"),
                    deps = parseDependencies(extractDependencyEntries(props)),
                    buildDeps = props.getProperty(BUILD_DEPS, "").split(",").filter { it.isNotBlank() },
                    rootPath = props.getProperty(ROOT_PATH)?.let { Path(it) },
                    entryPointPath = props.getProperty(ENTRY_POINT_PATH)?.let { Path(it) },
                    sourcesAreGenerated = props.getProperty(SOURCES_ARE_GENERATED).toBoolean(),
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
        const val NAME = "name"
        const val PATH = "path"
        const val ROOT_PATH = "root.path"
        const val TYPE = "type"
        const val SOURCES_ARE_GENERATED = "sources.are.generated"
        const val VERSION = "version"
    }

    private object Paths {
        const val EXTERNAL = "external"
        const val EXTERNAL_PLACEHOLDER = "{external}"
    }
}
