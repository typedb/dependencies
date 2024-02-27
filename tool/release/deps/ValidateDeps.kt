package com.vaticle.dependencies.tool.release.deps

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonObject
import java.io.File
import java.io.FileReader
import java.nio.file.Paths

fun main() {
    val workspaceRefsPath = "{workspace_refs_json_path}"
    val versionFilePath = "{version_file_path}"
    val taggedDeps = "{tagged_deps}"

    val rawTaggedDepsSet = taggedDeps.split(",").toSet()
    val malformedDepsSet = rawTaggedDepsSet.filter { dep -> !dep.startsWith("@") }
    if (malformedDepsSet.isNotEmpty()) {
        System.err.println("\nThe following dependencies do not start with an '@': $malformedDepsSet")
        System.err.println("Please prefix them with '@', ie., ${malformedDepsSet.map { dep -> "@" + dep }}'")
        System.exit(1)
    }
    val taggedDepsSet = rawTaggedDepsSet.map { w -> w.replace("@", "") }

    val refs = Paths.get(workspaceRefsPath)
    val refFileReader = FileReader(refs.toFile())
    val parsed = Json.parse(refFileReader).asObject()

    val taggedDepsFromRefs = parsed["tags"].asObject().names().toSet()
    val snapshotDependencies = taggedDepsSet.subtract(taggedDepsFromRefs)

    if (snapshotDependencies.size > 0) {
        System.err.println("\nThese dependencies are expected to be declared by tag instead of commit: $snapshotDependencies")
        System.exit(1)
    }

    val version = File(versionFilePath).readText().trim()
    if (!version.lowercase().contains("rc")) {
        var rcDeps = parsed["tags"].asObject().iterator().asSequence()
            .filter { taggedDepsSet.contains(it.name) && it.value.asString().lowercase().contains("rc") }
            .map { it.name + ": " + it.value.asString()}
            .toList()
        if (rcDeps.size > 0) {
            System.err.println("\nFound these RC dependencies in a non-RC release $version: ${rcDeps}")
            System.exit(1)
        }
    }
}
