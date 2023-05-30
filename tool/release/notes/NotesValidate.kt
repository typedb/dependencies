/*
 *  Copyright (C) 2022 Vaticle
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Affero General Public License as
 *  published by the Free Software Foundation, either version 3 of the
 *  License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU Affero General Public License for more details.
 *
 *  You should have received a copy of the GNU Affero General Public License
 *  along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 */

package com.vaticle.dependencies.tool.release.notes

import java.nio.file.Paths
import kotlin.io.path.notExists

fun main(args: Array<String>) {
    val bazelWorkspaceDir = Paths.get(getEnv("BUILD_WORKSPACE_DIRECTORY"))
    val githubToken = getEnv("NOTES_VALIDATE_TOKEN")
    if (args.size != 3) throw RuntimeException("org, repo, release notes file must be supplied")

    val org = args[0]
    val repo = args[1]
    val releaseNotesFile = args[2]
    val releaseNotesPath = bazelWorkspaceDir.resolve(releaseNotesFile)
    if (releaseNotesPath.notExists()) throw RuntimeException("Release notes file '$releaseNotesPath' does not exist.")

    val lastTag = getLastVersion(org, repo, githubToken)

    val result = bash("git diff --exit-code $lastTag HEAD -- $releaseNotesFile", bazelWorkspaceDir)
    if (result.getExitValue() == 0) {
        println("Error: the release notes file '$releaseNotesFile' has not changed since the last release (tag '$lastTag').")
    }
}