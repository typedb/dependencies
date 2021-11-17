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
import com.vaticle.dependencies.tool.release.createnotes.Constant.github
import java.nio.file.Path

fun getCommits(org: String, repo: String, current: Version, to: String, baseDir: Path, githubToken: String): List<String> {
    val preceding = getPrecedingVersion(org, repo, current, githubToken)
    if (preceding != null) {
        val response = httpGet("$github/repos/$org/$repo/compare/$preceding...$to", githubToken)
        val body = Json.parse(String(response.content.readBytes()))
        return body.asObject().get("commits").asArray().map { e -> e.asObject().get("sha").asString() }
    }
    else {
        val gitRevList = bash("git rev-list --max-parents=0 HEAD", baseDir)
        val firstCommit = gitRevList.outputString().trim()
        val response = httpGet("$github/repos/$org/$repo/compare/$firstCommit...$to", githubToken)
        val body = Json.parse(String(response.content.readBytes()))
        return listOf(firstCommit) + body.asObject().get("commits").asArray().map { e -> e.asObject().get("sha").asString() }.toList()
    }
}

private fun getPrecedingVersion(org: String, repo: String, current: Version, githubToken: String): Version? {
    val response = httpGet("$github/repos/$org/$repo/releases", githubToken)
    val body = Json.parse(String(response.content.readBytes()))
    val releases = mutableListOf<Version>()
    releases.add(current)
    releases.addAll(body.asArray().map { e -> Version.parse(e.asObject().get("tag_name").asString()) })
    releases.sort()
    val currentIdx = releases.indexOf(current)
    val preceding =
        if (currentIdx >= 1) releases[currentIdx - 1]
        else if (currentIdx == 0) null
        else throw IllegalStateException("")
    println("preceding version: $preceding")
    return preceding
}
