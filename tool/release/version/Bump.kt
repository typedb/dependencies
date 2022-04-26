package com.vaticle.dependencies.tool.release.version

import java.nio.file.Files
import java.nio.file.Paths

fun bumpVersion(version: String): String {
    val versionComponents = version.split(".").toTypedArray()

    if (versionComponents.size != 3) {
        throw RuntimeException("Version is supposed to have three components: x.y.z")
    }
    var lastVersionComponent = versionComponents[versionComponents.lastIndex]

    try {
        // regular version component ("0")
        lastVersionComponent = (Integer.parseInt(lastVersionComponent) + 1).toString()
    } catch (a: NumberFormatException) {
        // must be a snapshot version "0-alpha-X" where X needs to be incremented
        val versionSubComponents = lastVersionComponent.split("-").toTypedArray()
        try {
            versionSubComponents[versionSubComponents.lastIndex] = (
                    Integer.parseInt(versionSubComponents[versionSubComponents.lastIndex]) + 1
                    ).toString()
            lastVersionComponent = versionSubComponents.joinToString("-")
        } catch (b: NumberFormatException) {
            throw RuntimeException("invalid version: ${version}")
        }
    }
    versionComponents[versionComponents.lastIndex] = lastVersionComponent
    return versionComponents.joinToString(".")
}

fun main() {
    val workspaceDirectory = System.getenv("BUILD_WORKSPACE_DIRECTORY")
            ?: throw RuntimeException("Not running from within Bazel workspace")

    val versionFile = Paths.get(workspaceDirectory, "VERSION")
    val version = String(Files.readAllBytes(versionFile)).trim()
    val newVersion = bumpVersion(version)

    println("Bumping the version to $newVersion")
    Files.write(versionFile, newVersion.toByteArray())
}
