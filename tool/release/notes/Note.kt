/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package com.typedb.dependencies.tool.release.notes

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonArray
import com.eclipsesource.json.JsonObject
import com.typedb.dependencies.tool.release.notes.Constant.labelBug
import com.typedb.dependencies.tool.release.notes.Constant.labelFeature
import com.typedb.dependencies.tool.release.notes.Constant.github
import com.typedb.dependencies.tool.release.notes.Constant.labelPrefix
import com.typedb.dependencies.tool.release.notes.Constant.labelRefactor

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

    fun toMarkdown(): String {
        val title = title.trim()
        val goal = if (goal != null) goal.prependIndent("  ") else ""
        return "- **$title**\n$goal"
    }

    companion object {
        fun fromGithubPR(pr: JsonObject): Note {
            val bodyJsonValue = pr.get("body");
            return Note(
                    title = pr.get("title").asString(),
                    goal = getPRGoal(if (bodyJsonValue.isNull) null else bodyJsonValue.asString()),
                    type = getPRType(pr.get("labels").asArray())
            )
        }

        private fun getPRType(labels: JsonArray): Type {
            val types = labels
                    .map { label -> label.asObject().get("name").asString() }
                    .filter { label -> label.startsWith(labelPrefix) }
            return when {
                types.contains(labelFeature) -> Type.FEATURE
                types.contains(labelBug) -> Type.BUG
                types.contains(labelRefactor) -> Type.REFACTOR
                else -> Type.OTHER
            }
        }

        private fun getPRGoal(description: String?): String? {
            if (description == null) return null
            val goal = StringBuilder()
            var header = 0
            for (line in description.lines()) {
                if (line.startsWith("## ")) {
                    header += 1
                } else if (header == 1) {
                    goal.append(line).append("\n")
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
    val seenPRs = HashSet<Int>()
    return commits.flatMap { commit ->
        val pullsRes = httpGet("$github/repos/$org/$repo/commits/$commit/pulls", githubToken)
        val pullsJSON = Json.parse(pullsRes.parseAsString())
        val prs = pullsJSON.asArray().filterNot { pr -> seenPRs.contains(pr.asObject().get("number").asInt()) }
        if (prs.size > 0) {
            val notes = prs.map { pr ->
                val prNumber = pr.asObject().get("number").asInt()
                println("collecting PR #$prNumber from commit '$commit'...")
                seenPRs.add(prNumber)
                Note.fromGithubPR(pr.asObject())
            }
            notes
        } else {
            println("collecting commit '$commit'...")
            val commitRes = httpGet("$github/repos/$org/$repo/commits/$commit", githubToken)
            val commitJSON = Json.parse(commitRes.parseAsString())
            val notes = listOf(Note.fromGithubCommit(commitJSON.asObject().get("commit").asObject()))
            notes
        }
    }
}

