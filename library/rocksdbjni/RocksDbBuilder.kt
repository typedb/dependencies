package library.rocksdbjni

import org.zeroturnaround.exec.ProcessExecutor
import org.zeroturnaround.exec.ProcessResult
import java.io.File
import java.nio.file.Paths

fun main() {
    val baseDir = Paths.get(".")
    val version = Paths.get("library").resolve("rocksdbjni").resolve("VERSION").toFile().useLines { it.firstOrNull() }

    val javaHome = shellScript("/usr/libexec/java_home", Paths.get(".").toFile(), ".")!!.outputUTF8().trim()

    shellScript("git clone git@github.com:facebook/rocksdb.git", baseDir.toFile(), javaHome)

    val rocksDbDir = Paths.get("rocksdb")
    shellScript("git checkout v$version", rocksDbDir.toFile(), javaHome)

    shellScript("brew install cmake", rocksDbDir.toFile(), javaHome)

    shellScript("make clean jclean", rocksDbDir.toFile(), javaHome)

    shellScript("make -j8 rocksdbjava", rocksDbDir.toFile(), javaHome)

    val srcMainJavaDir = Paths.get("rocksdb", "java", "src", "main", "java")
    val sourcesJarName = "rocksdbjni-$version-sources.jar"
    shellScript("jar -cf ../../../target/$sourcesJarName org", srcMainJavaDir.toFile(), javaHome)

    val versionedJarName = "rocksdbjni-$version-osx.jar"
    val jar = rocksDbDir.resolve("java").resolve("target").resolve(versionedJarName).toFile()
    val destPath = Paths.get("rocksdbjni-osx.jar").toFile()
    jar.copyTo(destPath)

    val sourcesJar = rocksDbDir.resolve("java").resolve("target").resolve(sourcesJarName).toFile()
    val sourcesDestPath = Paths.get("rocksdbjni-sources.jar").toFile()
    sourcesJar.copyTo(sourcesDestPath)
}

fun shellScript(cmd: String, baseDir: File, javaHome: String): ProcessResult? {
    println(cmd)
    return ProcessExecutor(cmd.split(" "))
            .readOutput(true)
            .redirectOutput(System.out).redirectError(System.err)
            .environment("JAVA_HOME", javaHome)
            .directory(baseDir).execute()
}
