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
import com.eclipsesource.json.JsonValue
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelBug
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelFeature
import com.vaticle.dependencies.tool.release.createnotes.Constant.github
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelPrefix
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelRefactor

data class CommitInfo(val title: String, val goal: String?, val type: Type) {
    enum class Type { FEATURE, BUG, REFACTOR, OTHER }
}

fun getCommitInfos(org: String, repo: String, commits: List<String>, githubToken: String): List<CommitInfo> {
    return commits.flatMap { commit ->
        val response = httpGet("$github/repos/$org/$repo/commits/$commit/pulls", githubToken)
        val body = Json.parse(String(response.content.readBytes()))
        val prs = body.asArray()
        if (prs.size() > 0) {
            val notes = prs.map { pr ->
                val prNumber = pr.asObject().get("number").asInt()
                println("collecting commit '$commit' from PR #$prNumber...")
                val types = pr.asObject().get("labels").asArray().map { e -> e.asObject().get("name").asString() }
                    .filter { e -> e.startsWith(labelPrefix) }
                val type =
                    when {
                        types.contains(labelFeature) -> CommitInfo.Type.FEATURE
                        types.contains(labelBug) -> CommitInfo.Type.BUG
                        types.contains(labelRefactor) -> CommitInfo.Type.REFACTOR
                        else -> CommitInfo.Type.OTHER
                    }
                CommitInfo(
                    title = pr.asObject().get("title").asString(),
                    goal = getPRGoal(pr.asObject().get("body").asString()),
                    type = type
                )
            }
            notes
        } else {
            println("collecting commit '$commit'...")
            val response = httpGet("$github/repos/$org/$repo/commits/$commit", githubToken)
            val body = Json.parse(String(response.content.readBytes()))
            val notes = listOf(
                CommitInfo(title = getCommitTitle(body), goal = null, type = CommitInfo.Type.OTHER)
            )
            notes
        }
    }
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

// only take the first line of the commit message, since the second line onwards are most likely implementation detail
private fun getCommitTitle(body: JsonValue): String {
    return body.asObject().get("commit").asObject().get("message").asString().lines().first()
}
