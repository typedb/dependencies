package com.vaticle.dependencies.tool.checkstyle.templates

import java.nio.file.Paths
import kotlin.system.exitProcess

import com.vaticle.dependencies.util.bash

fun main() {
    val exitCode = bash("{command}", Paths.get("."), null, false).exitValue
    exitProcess(exitCode)
}
