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

fun getCommits(org: String, repo: String, current: Version, to: String, githubToken: String): List<String> {
    val preceding = getPrecedingVersion(org, repo, current, githubToken)
    val from_ = preceding?.toString() ?: TODO() // "d67639340ebf55a76e1f8cbd0fd7194cd212da02"
    val response = httpGet("$github/repos/$org/$repo/compare/$from_...$to", githubToken)
    val body = Json.parse(String(response.content.readBytes()))
    return body.asObject().get("commits").asArray().map { e -> e.asObject().get("sha").asString() }
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
