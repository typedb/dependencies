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

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonObject
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelBug
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelFeature
import com.vaticle.dependencies.tool.release.createnotes.Constant.github
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelPrefix
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelRefactor

class Note {
    enum class Type { FEATURE, BUG, REFACTOR, OTHER }

    private val title: String
    private val goal: String?
    private val type: Type

    private constructor(title: String, goal: String?, type: Type) {
        this.title = title
        this.goal = goal
        this.type = type
    }

    fun toMarkdown():  String {
        return "- **$title**\n  ${goal ?: ""}"
    }

    companion object {
        fun fromGithubPR(pr: JsonObject): Note {
            return Note(
                title = pr.get("title").asString(),
                goal = getPRGoal(pr.get("body").asString()),
                type = getPRType(pr.get("labels").asArray())
            )
        }

        private fun getPRType(labels: JsonArray): Type {
            val types = labels
                .map { e -> e.asObject().get("name").asString() }
                .filter { e -> e.startsWith(labelPrefix) }
            val type =
                when {
                    types.contains(labelFeature) -> Type.FEATURE
                    types.contains(labelBug) -> Type.BUG
                    types.contains(labelRefactor) -> Type.REFACTOR
                    else -> Type.OTHER
                }
            return type
        }

        private fun getPRGoal(description: String): String {
            val goal = StringBuilder()
            var header = 0
            for (line in description.lines()) {
                if (line.startsWith("##")) {
                    header += 1
                } else if (header == 1) {
                    goal.append(line)
                } else if (header > 1) {
                    break
                }
            }
            return goal.toString()
        }

        fun fromGithubCommit(commit: JsonObject): Note {
            return Note(commit.get("message").asString().lines().first(), null, Type.OTHER)
        }

        fun toMarkdown(notes: List<Note>): String {
            val features = mutableListOf<Note>()
            val bugs = mutableListOf<Note>()
            val refactors = mutableListOf<Note>()
            val others = mutableListOf<Note>()

            notes.forEach { note ->
                when (note.type) {
                    Type.FEATURE -> features.add(note)
                    Type.BUG -> bugs.add(note)
                    Type.REFACTOR -> refactors.add(note)
                    else -> others.add(note)
                }
            }

            return """
## New Features
${features.map(Note::toMarkdown).joinToString("\n")}

## Bugs Fixed
${bugs.map(Note::toMarkdown).joinToString("\n")}

## Code Refactors
${refactors.map(Note::toMarkdown).joinToString("\n")}

## Other Improvements
${others.map(Note::toMarkdown).joinToString("\n")}
    """
        }
    }
}

fun collectNotes(org: String, repo: String, commits: List<String>, githubToken: String): List<Note> {
    return commits.flatMap { commit ->
        val response = httpGet("$github/repos/$org/$repo/commits/$commit/pulls", githubToken)
        val body = Json.parse(String(response.content.readBytes()))
        val prs = body.asArray()
        if (prs.size() > 0) {
            val notes = prs.map { pr ->
                val prNumber = pr.asObject().get("number").asInt()
                println("collecting PR #$prNumber from commit '$commit'...")
                Note.fromGithubPR(pr.asObject())
            }
            notes
        } else {
            println("collecting commit '$commit'...")
            val response = httpGet("$github/repos/$org/$repo/commits/$commit", githubToken)
            val body = Json.parse(String(response.content.readBytes()))
            val notes = listOf(Note.fromGithubCommit(body.asObject().get("commit").asObject()))
            notes
        }
    }
}

