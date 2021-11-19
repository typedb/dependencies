package com.vaticle.dependencies.tool.release.createnotes

import com.google.api.client.http.GenericUrl
import com.google.api.client.http.HttpHeaders
import com.google.api.client.http.HttpResponse
import com.google.api.client.http.javanet.NetHttpTransport
import org.zeroturnaround.exec.ProcessExecutor
import org.zeroturnaround.exec.ProcessResult
import java.nio.file.Path

object Constant {
    val releaseTemplateRegex = "\\{\\s*release notes\\s*}".toRegex()
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

fun bash(script: String, baseDir: Path): ProcessResult {
    val builder = ProcessExecutor(script.split(" "))
        .readOutput(true)
        .redirectOutput(System.out)
        .redirectError(System.err)
        .directory(baseDir.toFile())
        .exitValueNormal()
    return builder.execute()
}
