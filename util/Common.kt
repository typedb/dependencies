package com.vaticle.dependencies.util

import org.zeroturnaround.exec.ProcessExecutor
import org.zeroturnaround.exec.ProcessResult
import java.nio.file.Path

fun bash(script: String, baseDir: Path, javaHome: Path?, expectExitValueNormal: Boolean): ProcessResult {
    println("=== Running: '$script'")
    var builder = ProcessExecutor(script.split(" "))
            .readOutput(true)
            .redirectOutput(System.out)
            .redirectError(System.err)
            .directory(baseDir.toFile())
    if (javaHome != null) {
        builder = builder.environment("JAVA_HOME", javaHome.toAbsolutePath().toString())
    }
    if (expectExitValueNormal) {
        builder = builder.exitValueNormal()
    }
    val execution = builder.execute()
    println("=== Execution finished with status code '${execution.exitValue}'")
    println()
    return execution
}
