/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

package com.vaticle.dependencies.tool.github

import org.kohsuke.github.GitHub
import picocli.CommandLine
import java.util.concurrent.Callable
import kotlin.system.exitProcess

object OpenPR: Callable<Int> {
    @CommandLine.Option(names = ["--repo"], description = ["The repository to open the PR on"])
    private lateinit var repo: String

    @CommandLine.Option(names = ["--head-branch"], description = ["The merging branch"])
    private lateinit var headBranch: String

    @CommandLine.Option(names = ["--base-branch"], description = ["The branch being merged into"])
    private lateinit var baseBranch: String

    @CommandLine.Option(names = ["--title"], description = ["The title of the PR"])
    private lateinit var title: String

    @CommandLine.Option(names = ["--body"], description = ["The body of the PR"])
    private lateinit var body: String

    @CommandLine.Option(names = ["--token"], description = ["The GitHub authentication token"])
    private lateinit var token: String

    private const val USERNAME = "vaticle-bot"

    @JvmStatic
    fun main(args: Array<String>) {
        exitProcess(CommandLine(OpenPR).execute(*args))
    }

    override fun call(): Int {
        val gh = GitHub.connect(USERNAME, token)
        gh.getRepository(repo).createPullRequest(title, headBranch, baseBranch, body)
        return 0
    }
}
