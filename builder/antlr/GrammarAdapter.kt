package com.vaticle.dependencies.builder.antlr


import picocli.CommandLine
import picocli.CommandLine.Command
import picocli.CommandLine.Option
import java.io.File
import java.util.concurrent.Callable
import kotlin.system.exitProcess


@Command(name = "grammar-adapter", mixinStandardHelpOptions = true)
class GrammarAdapter : Callable<Unit> {

    @Option(names = ["--in"], required = true)
    lateinit var inputFile: File

    @Option(names = ["--out"], required = true)
    lateinit var outputFile: File

    @Option(names = ["--adapt-keyword"], required = true)
    lateinit var keywords: Array<String>

    var patterns = ArrayList<Regex>()

    override fun call() {
        val grammarRenamePattern = Regex("grammar (${inputFile.nameWithoutExtension})")

        for (keyword in keywords) {
            // keyword at the beginning of the line followed by whitespace, signifying the rule name
            patterns.add(Regex("^($keyword)\\s"))
            // keyword surrounded by two whitespaced, signifying the rule usage
            patterns.add(Regex("\\s($keyword)\\s"))
        }
        outputFile.bufferedWriter().use { writer ->
            for (line in inputFile.readLines()) {
                var newLine = line
                for (pattern in patterns) {
                    // replacements need to be done backwards for indexes to not be shifted
                    for (match in pattern.findAll(line).toCollection(arrayListOf()).reversed()) {
                        val newToken = match.groups[1]!!.value
                        newLine = newLine.replaceRange(match.groups[1]!!.range, "${newToken}_")
                    }
                }
                newLine = grammarRenamePattern.replace(newLine, "grammar ${outputFile.nameWithoutExtension}")
                writer.write(newLine)
                writer.newLine()
            }
        }
    }
}

fun main(args: Array<String>): Unit = exitProcess(CommandLine(GrammarAdapter()).execute(*args))
