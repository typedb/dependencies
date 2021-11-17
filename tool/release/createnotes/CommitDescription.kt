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
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelBug
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelFeature
import com.vaticle.dependencies.tool.release.createnotes.Constant.github
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelPrefix
import com.vaticle.dependencies.tool.release.createnotes.Constant.labelRefactor

data class CommitDescription(val title: String, val desc: String, val type: Type) {
    enum class Type { FEATURE, BUG, REFACTOR, OTHER }
}

fun getCommitDescriptions(org: String, repo: String, commits: List<String>, githubToken: String): List<CommitDescription> {
    return commits.flatMap { commit ->
        println("collecting description for commit '$commit'...")
        val response = httpGet("$github/repos/$org/$repo/commits/$commit/pulls", githubToken)
        val body = Json.parse(String(response.content.readBytes()))
        val prs = body.asArray()
        if (prs.size() > 0) {
            val notes = prs.map { pr ->
                val types = pr.asObject().get("labels").asArray().map { e -> e.asObject().get("name").asString() }
                    .filter { e -> e.startsWith(labelPrefix) }
                val type =
                    if (types.contains(labelFeature)) CommitDescription.Type.FEATURE
                    else if (types.contains(labelBug)) CommitDescription.Type.BUG
                    else if (types.contains(labelRefactor)) CommitDescription.Type.REFACTOR
                    else CommitDescription.Type.OTHER
                CommitDescription(
                    title = pr.asObject().get("title").asString(),
                    desc = pr.asObject().get("body").asString(),
                    type = type
                )
            }
            notes
        } else {
            val response = httpGet("$github/repos/$org/$repo/commits/$commit", githubToken)
            val body = Json.parse(String(response.content.readBytes()))
            // only take the first line of the commit message, since the second line onwards are most likely implementation detail
            val title = body.asObject().get("commit").asObject().get("message").asString().lines().first()
            val notes = listOf(
                CommitDescription(title = title, desc = "", type = CommitDescription.Type.OTHER)
            )
            notes
        }
    }
}