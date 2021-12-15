package com.vaticle.dependencies.library.rocksdbjni

import java.nio.file.Paths

fun main() {
    try {
        val baseDir = Paths.get(".")
        val version = Paths.get("library").resolve("rocksdbjni").resolve("VERSION").toFile().useLines { it.firstOrNull() }

        val javaHome = Paths.get("/usr/lib/jvm/java-11-openjdk-amd64")

        bash("git clone https://github.com/facebook/rocksdb.git", baseDir, javaHome, true)

        val rocksDbDir = Paths.get("rocksdb").toAbsolutePath()
        bash("git checkout v$version", rocksDbDir, javaHome, true)

        bash("sudo apt install cmake", rocksDbDir, javaHome, false)

        bash("make clean jclean", rocksDbDir, javaHome, true)

        // use 'make DEBUG_LEVEL=0 ...' to build production binary
        bash("make -j8 rocksdbjava", rocksDbDir, javaHome, true)

        println(">>>>>>>>>>>>>>>>>>>>> baseDir")
        bash("ls ${baseDir}", rocksDbDir, javaHome, true)
        println(">>>>>>>>>>>>>>>>>>>>>")

        println(">>>>>>>>>>>>>>>>>>>>> rocksDbDir")
        bash("ls ${rocksDbDir}", rocksDbDir, javaHome, true)
        println(">>>>>>>>>>>>>>>>>>>>>")

        println(">>>>>>>>>>>>>>>>>>>>> rocksDbDir.resolve(\"java\")")
        bash("ls ${rocksDbDir.resolve("java")}", rocksDbDir, javaHome, true)
        println(">>>>>>>>>>>>>>>>>>>>>")

        println(">>>>>>>>>>>>>>>>>>>>> rocksDbDir.resolve(\"java\").resolve(\"target\")")
        bash("ls ${rocksDbDir.resolve("java").resolve("target")}", rocksDbDir, javaHome, true)
        println(">>>>>>>>>>>>>>>>>>>>>")

        val versionedJarName = "rocksdbjni-$version-linux64.jar"
        println(">>>>>>>>>>>>>>>>>>>>>")

        println("1")
        val jar = rocksDbDir.resolve("java").resolve("target").resolve(versionedJarName).toFile()
        println("2")
        val destPath = Paths.get("rocksdbjni-linux.jar").toAbsolutePath().toFile()
        println("3")
        jar.copyTo(destPath)
        println("4")
        println(">>>>>>>>>>>>>>>>>>>>> destPath")
        bash("ls ${destPath.parent}", rocksDbDir, javaHome, true)
        println(">>>>>>>>>>>>>>>>>>>>>")
    } catch (e: Throwable) {
        e.printStackTrace()
        throw e;
    }
}