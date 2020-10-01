package library.rocksdbjni

import org.zeroturnaround.exec.ProcessExecutor
import org.zeroturnaround.exec.ProcessResult
import java.io.File
import java.nio.file.Paths

const val VERSION = "6.8.1"

fun main() {
    val baseDir = Paths.get(".")
    val javaHome = "/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home"

    shellScript("git clone git@github.com:facebook/rocksdb.git", baseDir.toFile(), javaHome)

    val gitRepoDir = Paths.get("rocksdb")
    shellScript("git checkout v$VERSION", gitRepoDir.toFile(), javaHome)

    shellScript("brew install cmake", gitRepoDir.toFile(), javaHome)

    shellScript("make clean jclean", gitRepoDir.toFile(), javaHome)

    shellScript("make -j8 rocksdbjava", gitRepoDir.toFile(), javaHome)

    val jarName = "rocksdbjni-$VERSION-osx.jar"
    val jar = gitRepoDir.resolve("java").resolve("target").resolve(jarName).toFile()
    val destPath = Paths.get(jarName).toFile()
    jar.copyTo(destPath)
}

fun shellScript(cmd: String, baseDir: File, javaHome: String): ProcessResult? {
    println(cmd)
    return ProcessExecutor(cmd.split(" "))
            .redirectOutput(System.out).redirectError(System.err)
            .environment("JAVA_HOME", javaHome)
            .directory(baseDir).execute()
}
