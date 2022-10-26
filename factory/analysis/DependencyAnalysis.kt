package com.vaticle.dependencies.factory.analysis

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonObject
import org.zeroturnaround.exec.ProcessExecutor
import java.io.ByteArrayOutputStream
import java.nio.file.Files
import java.nio.file.Paths
import java.util.regex.Pattern

fun httpPost(url: String, json: JsonObject) {
    val output = ByteArrayOutputStream()
    val expectedCode = "201"
    ProcessExecutor(
            "curl", "--silent",
            "--output", "-",
            "--write-out", "%{http_code}",
            "-H", "Content-Type: application/json",
            "--data", json.toString(),
            url)
            .redirectOutput(output)
            .redirectError(System.err)
            .exitValueNormal()
            .execute()
    if (!output.toString().equals(expectedCode)) {
        throw RuntimeException("Error while posting status; got '${output.toString()}' instead!")
    }
}

fun main() {
    val remotePattern = Pattern.compile("remote = \"(https://github.com/|git@github.com:)(?<remote>[^.\"]*)(?:.git)?\"(?:.*)");
    val refPattern = Pattern.compile("(?<type>commit|tag) = \"(?<ref>.*)\"(?:.*)");

    val workspaceDirectory = System.getenv("BUILD_WORKSPACE_DIRECTORY")
            ?: throw RuntimeException("Not running from within Bazel workspace")
    val factoryURL = System.getenv("FACTORY_URL") ?: throw RuntimeException("FACTORY_URL environment variable is not set")
    val factoryEndpoint = "/api/analysis/dependency-analysis"
    val workflow = System.getenv("FACTORY_WORKFLOW")
            ?: throw RuntimeException("FACTORY_WORKFLOW environment variable is not set")
    val dependencies = Paths.get(workspaceDirectory, "dependencies", "vaticle", "repositories.bzl")

    var repositoriesArray = Json.array()

    Files.readAllLines(dependencies).windowed(size = 2, step = 1).map { window ->
        window.map { it.trim(' ', ',', '\t') }
    }.mapNotNull { window ->
        val remotePatternMatcher = remotePattern.matcher(window.first())
        val refPatternMatcher = refPattern.matcher(window.last())
        if (!(remotePatternMatcher.matches() && refPatternMatcher.matches())) {
            return@mapNotNull null
        }
        mapOf(
                "remote" to remotePatternMatcher.group("remote"),
                refPatternMatcher.group("type") to refPatternMatcher.group("ref")
        )
    }.map {
        var obj = Json.`object`()
        for ((k, v) in it) {
            obj = obj.add(k, v)
        }
        repositoriesArray = repositoriesArray.add(obj)
    }

    val dependencyAnalysis = Json.`object`().add("workflow", workflow).add("commit-dependency", repositoriesArray)
    val payload = Json.`object`().add("dependency-analysis", dependencyAnalysis)
    httpPost(factoryURL + factoryEndpoint, payload)
}
