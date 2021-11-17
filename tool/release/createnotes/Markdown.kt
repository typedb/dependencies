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

import com.vaticle.dependencies.tool.release.createnotes.Constant.installInstruction
import com.vaticle.dependencies.tool.release.createnotes.Constant.releaseTemplateRegex
import java.lang.RuntimeException
import java.nio.file.Files
import java.nio.file.Path
import kotlin.text.Charsets.UTF_8

fun createCommitNoteMd(description: CommitDescription): String {
    val desc = StringBuilder()
    var header = 0
    for (line in description.desc.lines()) {
        if (line.startsWith("##")) {
            header += 1
        } else if (header == 1) {
            desc.append(line)
        } else if (header > 1) {
            break
        }
    }
    return "- **${description.title}**\n  $desc"
}

fun writeReleaseNoteMd(commitDescriptions: List<CommitDescription>, releaseTemplateFile: Path) {
    val template = String(Files.readAllBytes(releaseTemplateFile), UTF_8)
    if (!template.matches(releaseTemplateRegex)) throw RuntimeException("The release-template does not contain the '${releaseTemplateRegex}' placeholder")

    val features = mutableListOf<CommitDescription>()
    val bugs = mutableListOf<CommitDescription>()
    val refactors = mutableListOf<CommitDescription>()
    val others = mutableListOf<CommitDescription>()

    commitDescriptions.forEach { note ->
        when (note.type) {
            CommitDescription.Type.FEATURE -> features.add(note)
            CommitDescription.Type.BUG -> bugs.add(note)
            CommitDescription.Type.REFACTOR -> refactors.add(note)
            else -> others.add(note)
        }
    }

    val markdown = """
Install & Run: $installInstruction

## New Features
${features.map { feature -> createCommitNoteMd(feature) }.joinToString("\n")}

## Bugs Fixed
${bugs.map { bug -> createCommitNoteMd(bug) }.joinToString("\n")}

## Code Refactors
${refactors.map { refactor -> createCommitNoteMd(refactor) }.joinToString("\n")}

## Other Improvements
${others.map { other -> createCommitNoteMd(other) }.joinToString("\n")}
    """

    Files.write(releaseTemplateFile, template.replace(releaseTemplateRegex, markdown).toByteArray(UTF_8))
}
