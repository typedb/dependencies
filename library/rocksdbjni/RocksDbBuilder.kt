package library.rocksdbjni

import org.zeroturnaround.exec.ProcessExecutor
import org.zeroturnaround.exec.ProcessResult
import java.nio.file.Path
import java.nio.file.Paths

fun main() {
    val baseDir = Paths.get(".")
    val version = Paths.get("library").resolve("rocksdbjni").resolve("VERSION").toFile().useLines { it.firstOrNull() }
    val javaHome = Paths.get(shellScript("/usr/libexec/java_home", baseDir, null)!!.outputUTF8().trim())

    shellScript("git clone git@github.com:facebook/rocksdb.git", baseDir, javaHome)

    val rocksDbDir = Paths.get("rocksdb")
    shellScript("git checkout v$version", rocksDbDir, javaHome)

    shellScript("brew install cmake", rocksDbDir, javaHome)

    shellScript("make clean jclean", rocksDbDir, javaHome)

    shellScript("make -j8 rocksdbjava", rocksDbDir, javaHome)

    val srcMainJavaDir = Paths.get("rocksdb", "java", "src", "main", "java")
    val sourcesJarName = "rocksdbjni-$version-sources.jar"
    shellScript("jar -cf ../../../target/$sourcesJarName org", srcMainJavaDir, javaHome)

    val versionedJarName = "rocksdbjni-$version-osx.jar"
    val jar = rocksDbDir.resolve("java").resolve("target").resolve(versionedJarName).toFile()
    val destPath = Paths.get("rocksdbjni-osx.jar").toFile()
    jar.copyTo(destPath)

    val sourcesJar = rocksDbDir.resolve("java").resolve("target").resolve(sourcesJarName).toFile()
    val sourcesDestPath = Paths.get("rocksdbjni-sources.jar").toFile()
    sourcesJar.copyTo(sourcesDestPath)
}

fun shellScript(script: String, baseDir: Path, javaHome: Path?): ProcessResult? {
    println(script)
    var builder = ProcessExecutor(script.split(" "))
            .readOutput(true)
            .redirectOutput(System.out)
            .redirectError(System.err)
            .directory(baseDir.toFile())
    if (javaHome != null) {
        builder = builder.environment("JAVA_HOME", javaHome.toAbsolutePath().toString())
    }
    return builder.execute()
}
