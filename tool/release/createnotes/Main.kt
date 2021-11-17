/*
 * Copyright (C) 2021 Vaticle
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

package com.vaticle.dependencies.tool.release.createnotes

import java.nio.file.Paths
import kotlin.io.path.notExists

fun main(args: Array<String>) {
    val bazelWorkspaceDir = getEnv("BUILD_WORKSPACE_DIRECTORY")
    val githubToken = getEnv("CREATE_NOTES_TOKEN")
    if (args.size != 5) throw RuntimeException("org, repo, version, commit, and release-template must be supplied")
    val org = args[0]
    val repo = args[1]
    val version = args[2]
    val toBeReleased = args[3]
    val releaseTemplateFile = Paths.get(bazelWorkspaceDir, args[4])
    if (releaseTemplateFile.notExists()) throw RuntimeException("Release template file does not exist")

    val releaseTemplateRegex = "\\{\\srelease notes\\s}".toRegex()

    println("repository: $org/$repo")
    println("commit: $toBeReleased")
    val lastRelease = getLastRelease(org, repo, githubToken)
    val commits = getCommits(org, repo, lastRelease, toBeReleased, githubToken)
    val commitDescriptions = getCommitDescriptions(org, repo, commits, githubToken)
    writeReleaseNoteMd(commitDescriptions, releaseTemplateFile, releaseTemplateRegex)
}

private fun getEnv(env: String): String {
    if (System.getenv(env) == null) throw RuntimeException("'$env' environment variable must be set.")
    return System.getenv(env)
}