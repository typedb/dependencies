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
    val bazelWorkspaceDir = Paths.get(getEnv("BUILD_WORKSPACE_DIRECTORY"))
    val githubToken = getEnv("CREATE_NOTES_TOKEN")
    if (args.size != 5) throw RuntimeException("org, repo, version, commit, and template must be supplied")
    val (org, repo, version, commit, templateFileLocation) = args
    val templateFile = bazelWorkspaceDir.resolve(templateFileLocation)
    if (templateFile.notExists()) throw RuntimeException("Template file '$templateFile' does not exist.")

    println("Repository: $org/$repo")
    println("Commit: $commit")
    println("Version: $version")

    val commits = collectCommits(org, repo, Version.parse(version), commit, bazelWorkspaceDir, githubToken)
    println("Found ${commits.size} commits to be collected into the release note.")
    val commitInfos = getCommitInfos(org, repo, commits, githubToken)
    createNotesMd(commitInfos, templateFile)
}

private fun getEnv(env: String): String {
    return System.getenv(env) ?: throw RuntimeException("'$env' environment variable must be set.")
}
