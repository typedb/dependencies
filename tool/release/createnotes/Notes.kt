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

fun createNotesMd(commitInfos: List<CommitInfo>, releaseTemplateFile: Path) {
    val template = String(Files.readAllBytes(releaseTemplateFile), UTF_8)
    if (!template.matches("[\\s\\S]*${releaseTemplateRegex.pattern}[\\s\\S]*".toRegex()))
        throw RuntimeException("The release-template does not contain the '${releaseTemplateRegex}' placeholder")

    val features = mutableListOf<CommitInfo>()
    val bugs = mutableListOf<CommitInfo>()
    val refactors = mutableListOf<CommitInfo>()
    val others = mutableListOf<CommitInfo>()

    commitInfos.forEach { note ->
        when (note.type) {
            CommitInfo.Type.FEATURE -> features.add(note)
            CommitInfo.Type.BUG -> bugs.add(note)
            CommitInfo.Type.REFACTOR -> refactors.add(note)
            else -> others.add(note)
        }
    }

    val markdown = """
Install & Run: $installInstruction

## New Features
${features.map(::createNoteMd).joinToString("\n")}

## Bugs Fixed
${bugs.map(::createNoteMd).joinToString("\n")}

## Code Refactors
${refactors.map(::createNoteMd).joinToString("\n")}

## Other Improvements
${others.map(::createNoteMd).joinToString("\n")}
    """

    Files.write(releaseTemplateFile, template.replace(releaseTemplateRegex, markdown).toByteArray(UTF_8))
}

private fun createNoteMd(info: CommitInfo): String {
    return "- **${info.title}**\n  ${info.goal ?: ""}"
}
