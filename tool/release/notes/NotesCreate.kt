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

package com.vaticle.dependencies.tool.release.notes

import java.nio.file.Path
import java.nio.file.Paths
import kotlin.io.path.notExists
import kotlin.text.Regex.Companion.escapeReplacement

fun main(args: Array<String>) {
    val bazelWorkspaceDir = Paths.get(getEnv("BUILD_WORKSPACE_DIRECTORY"))
    val githubToken = getEnv("NOTES_CREATE_TOKEN")
    if (args.size != 6) throw RuntimeException("org, repo, commit, version, template, and output destination must be supplied")

    operator fun <T> Array<T>.component6() = this[5]
    val (org, repo, commit, version, templateFileLocation, outputFileLocation) = args

    val templateFile = bazelWorkspaceDir.resolve(templateFileLocation)
    if (templateFile.notExists()) throw RuntimeException("Template file '$templateFile' does not exist.")
    val outputFile = bazelWorkspaceDir.resolve(outputFileLocation)

    println("Commit: $org/$repo@$commit")
    println("Version: $version")

    val commits = collectCommits(org, repo, commit, Version.parse(version), bazelWorkspaceDir, githubToken)
    println("Found ${commits.size} commits to be collected into the release note.")
    val notes = collectNotes(org, repo, commits.reversed(), githubToken)
    writeNotesMd(notes, templateFile, outputFile)
}


private fun writeNotesMd(notes: List<Note>, releaseTemplateFile: Path, releaseNotesFile: Path) {
    val template = releaseTemplateFile.toFile().readText()
    if (!template.matches(".*${Constant.releaseTemplateRegex.pattern}.*".toRegex(RegexOption.DOT_MATCHES_ALL)))
        throw RuntimeException("The release-template does not contain the '${Constant.releaseTemplateRegex}' placeholder")
    val markdown = template.replace(Constant.releaseTemplateRegex, escapeReplacement(Note.toMarkdown(notes)))
    releaseNotesFile.toFile().writeText(markdown)
}
