/*
 * Copyright (C) 2018-present Vaticle
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

import com.eclipsesource.json.Json
import com.vaticle.dependencies.tool.release.notes.Constant.github
import java.nio.file.Path

fun collectCommits(org: String, repo: String, commit: String, version: Version, baseDir: Path, githubToken: String): List<String> {
    println("Determining the commits to be collected...")
    val preceding = getPrecedingVersion(org, repo, version, githubToken)
    if (preceding != null) {
        println("The script will collect commits down to the preceding version '$preceding'.")
        val response = httpGet("$github/repos/$org/$repo/compare/$preceding...$commit", githubToken)
        val body = Json.parse(response.parseAsString())
        return body.asObject().get("commits").asArray().map { cmt -> cmt.asObject().get("sha").asString() }
    }
    else {
        val gitRevList = bash("git rev-list --max-parents=0 HEAD", baseDir)
        val firstCommit = gitRevList.outputString().trim()
        println("No preceding version found. The script will collect all commits down to the first one: '$firstCommit'.")
        val response = httpGet("$github/repos/$org/$repo/compare/$firstCommit...$commit", githubToken)
        val body = Json.parse(response.parseAsString())
        val commits =
            body.asObject().get("commits").asArray().map { cmt -> cmt.asObject().get("sha").asString() }.toList()
        return listOf(firstCommit) + commits
    }
}

private fun getPrecedingVersion(org: String, repo: String, version: Version, githubToken: String): Version? {
    val response = httpGet("$github/repos/$org/$repo/releases", githubToken)
    val body = Json.parse(response.parseAsString())
    val tags = mutableListOf<Version>()
    tags.add(version)
    tags.addAll(body.asArray().map { release -> Version.parse(release.asObject().get("tag_name").asString()) })
    tags.sort()
    val currentIdx = tags.indexOf(version)
    val preceding =
        if (currentIdx >= 1) tags[currentIdx - 1]
        else if (currentIdx == 0) null
        else throw IllegalStateException("Version '$version' not found: currentIdx = '$currentIdx'")
    return preceding
}
