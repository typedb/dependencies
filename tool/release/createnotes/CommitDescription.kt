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
import com.google.api.client.http.GenericUrl
import com.google.api.client.http.HttpHeaders
import com.google.api.client.http.javanet.NetHttpTransport

data class CommitDescription(val title: String, val desc: String, val type: CommitDescriptionType)

enum class CommitDescriptionType { FEATURE, BUG, REFACTOR, OTHER }

fun getCommitDescriptions(org: String, repo: String, commits: List<String>, githubToken: String?): List<CommitDescription> {
    return commits.flatMap { commit ->
        val response = NetHttpTransport()
            .createRequestFactory()
            .buildGetRequest(GenericUrl("https://api.github.com/repos/$org/$repo/commits/$commit/pulls"))
            .setHeaders(
                HttpHeaders().setAuthorization("Token $githubToken").setAccept("application/vnd.github.v3+json")
            )
            .execute()
        val body = Json.parse(String(response.content.readBytes()))
        val prs = body.asArray()
        if (prs.size() > 0) {
            val notes = prs.map { pr ->
                val types = pr.asObject().get("labels").asArray().map { e -> e.asObject().get("name").asString() }
                    .filter { e -> e.startsWith("type:") }
                val type =
                    if (types.contains("type: feature")) CommitDescriptionType.FEATURE
                    else if (types.contains("type: bug")) CommitDescriptionType.BUG
                    else if (types.contains("type: refactor")) CommitDescriptionType.REFACTOR
                    else CommitDescriptionType.OTHER
                CommitDescription(
                    title = pr.asObject().get("title").asString(),
                    desc = pr.asObject().get("body").asString(),
                    type = type
                )
            }
            notes
        } else {
            val response = NetHttpTransport()
                .createRequestFactory()
                .buildGetRequest(GenericUrl("https://api.github.com/repos/$org/$repo/commits/$commit"))
                .setHeaders(
                    HttpHeaders().setAuthorization("Token $githubToken").setAccept("application/vnd.github.v3+json")
                )
                .execute()
            val body = Json.parse(String(response.content.readBytes()))
            val notes = listOf(
                CommitDescription(
                    title = body.asObject().get("commit").asObject().get("message").asString(),
                    desc = "",
                    type = CommitDescriptionType.OTHER
                )
            )
            notes
        }
    }
}