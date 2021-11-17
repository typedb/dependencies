package com.vaticle.dependencies.tool.release.createnotes

import com.google.api.client.http.GenericUrl
import com.google.api.client.http.HttpHeaders
import com.google.api.client.http.HttpResponse
import com.google.api.client.http.javanet.NetHttpTransport

object Constant {
    val releaseTemplateRegex = "\\{\\srelease notes\\s}".toRegex()
    const val installInstruction = "http://docs.vaticle.com/docs/running-typedb/install-and-run"
    const val github = "https://api.github.com"
    const val headerAccept = "\"application/vnd.github.v3+json"
    const val headerAuthPrefix = "Token"
    const val labelPrefix = "type"
    const val labelFeature = "$labelPrefix: feature"
    const val labelBug = "$labelPrefix: bug"
    const val labelRefactor = "$labelPrefix: refactor"
}

fun httpGet(url: String, githubToken: String): HttpResponse {
    return NetHttpTransport()
        .createRequestFactory()
        .buildGetRequest(GenericUrl(url))
        .setHeaders(
            HttpHeaders().setAuthorization("${Constant.headerAuthPrefix} $githubToken").setAccept(Constant.headerAccept)
        )
        .execute()
}