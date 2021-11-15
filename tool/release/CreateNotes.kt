package com.vaticle.dependencies.tool.release

import com.google.api.client.http.GenericUrl
import com.google.api.client.http.HttpHeaders
import com.google.api.client.http.javanet.NetHttpTransport
import java.nio.file.Paths
import kotlin.io.path.notExists
import com.eclipsesource.json.Json
import java.nio.charset.StandardCharsets.UTF_8
import java.nio.file.Files
import java.nio.file.Path

data class Version(val major: Int, val minor: Int, val patch: Int, val alpha: Int?): Comparable<Version> {
    companion object {
        fun parse(version: String): Version {
            val version1 = version.split("-")
            require(version1.isNotEmpty() && version1.size <= 3) {
                "version '$version1' does not follow the form 'x.y.z', 'x.y.z-alpha', or 'x.y.z-alpha-n'"
            }
            val version2 = version1[0].split(".")
            if (version1.size == 1) {
                require(version2.size == 3) { "version must be of the form x.y.z" }
                return Version(
                    major = version2[0].toInt(),
                    minor = version2[1].toInt(),
                    patch = version2[2].toInt(),
                    alpha = null
                )
            } else if (version1.size == 2) {
                return Version(
                    major = version2[0].toInt(),
                    minor = version2[1].toInt(),
                    patch = version2[2].toInt(),
                    alpha = 1
                )
            } else {
                return Version(
                    major = version2[0].toInt(),
                    minor = version2[1].toInt(),
                    patch = version2[2].toInt(),
                    alpha = version1[2].toInt()
                )
            }
        }
    }

    override fun compareTo(other: Version): Int {
        val major = major.compareTo(other.major)
        if (major == 0) {
            val minor = minor.compareTo(other.minor)
            if (minor == 0) {
                val patch = patch.compareTo(other.patch)
                if (patch == 0) {
                    if (alpha == null) {
                        if (other.alpha == null) return 0
                        else return 1
                    } else {
                        if (other.alpha != null) return alpha.compareTo(other.alpha)
                        else return -1
                    }
                } else return patch
            } else return minor
        } else return major
    }

    override fun toString(): String {
        return "$major.$minor.$patch" + (if (alpha != null) "-alpha-$alpha" else "")
    }
}

data class CommitNote(val title: String, val desc: String, val type: CommitNoteType)

enum class CommitNoteType { FEATURE, BUG, REFACTOR, OTHER }

fun getLastRelease(org: String, repo: String, githubToken: String): Version? {
    val response = NetHttpTransport()
        .createRequestFactory()
        .buildGetRequest(GenericUrl("https://api.github.com/repos/$org/$repo/releases"))
        .setHeaders(HttpHeaders().setAuthorization("Token $githubToken").setAccept("application/vnd.github.v3+json"))
        .execute()
    val body = Json.parse(String(response.content.readBytes()))
    val releases = body.asArray().map { e -> Version.parse(e.asObject().get("tag_name").asString()) }
    return releases.maxOrNull()
}

fun getCommits(org: String, repo: String, from: Version?, to: String, githubToken: String): List<String> {
    val from_ = "d67639340ebf55a76e1f8cbd0fd7194cd212da02" // from?.toString() ?: TODO("get first commit")
    val response = NetHttpTransport()
        .createRequestFactory()
        .buildGetRequest(GenericUrl("https://api.github.com/repos/$org/$repo/compare/$from_...$to"))
        .setHeaders(HttpHeaders().setAuthorization("Token $githubToken").setAccept("application/vnd.github.v3+json"))
        .execute()
    val body = Json.parse(String(response.content.readBytes()))
    return body.asObject().get("commits").asArray().map { e -> e.asObject().get("sha").asString() }
}

fun getCommitNotes(org: String, repo: String, commits: List<String>, githubToken: String?): List<CommitNote> {
    return commits.flatMap { commit ->
        val response = NetHttpTransport()
            .createRequestFactory()
            .buildGetRequest(GenericUrl("https://api.github.com/repos/$org/$repo/commits/$commit/pulls"))
            .setHeaders(
                HttpHeaders().setAuthorization("Token $githubToken").setAccept("application/vnd.github.v3+json")
            )
            .execute()
        val body = Json.parse(String(response.content.readBytes()))
        val prs = body.asArray()
        if (prs.size() > 0) {
            val notes = prs.map { pr ->
                val types = pr.asObject().get("labels").asArray().map { e -> e.asObject().get("name").asString() }
                    .filter { e -> e.startsWith("type:") }
                val type =
                    if (types.contains("type: feature")) CommitNoteType.FEATURE
                    else if (types.contains("type: bug")) CommitNoteType.BUG
                    else if (types.contains("type: refactor")) CommitNoteType.REFACTOR
                    else CommitNoteType.OTHER
                CommitNote(
                    title = pr.asObject().get("title").asString(),
                    desc = pr.asObject().get("body").asString(),
                    type = type
                )
            }
            notes
        } else {
            val response = NetHttpTransport()
                .createRequestFactory()
                .buildGetRequest(GenericUrl("https://api.github.com/repos/$org/$repo/commits/$commit"))
                .setHeaders(
                    HttpHeaders().setAuthorization("Token $githubToken").setAccept("application/vnd.github.v3+json")
                )
                .execute()
            val body = Json.parse(String(response.content.readBytes()))
            val notes = listOf(
                CommitNote(
                    title = body.asObject().get("commit").asObject().get("message").asString(),
                    desc = "",
                    type = CommitNoteType.OTHER
                )
            )
            notes
        }
    }
}

fun createCommitNote(note: CommitNote): String {
    var desc = StringBuilder()
    var header = 0
    for (line in note.desc.lines()) {
        if (line.startsWith("##")) {
            header += 1
        } else if (header == 1) {
            desc.append(line)
        } else if (header > 1) {
            break
        }
    }
    return "- **${note.title}**\n  $desc"
}

fun createReleaseNote(commitNotes: List<CommitNote>, releaseTemplateFile: Path) {
    val features = mutableListOf<CommitNote>()
    val bugs = mutableListOf<CommitNote>()
    val refactors = mutableListOf<CommitNote>()
    val others = mutableListOf<CommitNote>()

    commitNotes.forEach { note ->
        when (note.type) {
            CommitNoteType.FEATURE -> features.add(note)
            CommitNoteType.BUG -> bugs.add(note)
            CommitNoteType.REFACTOR -> refactors.add(note)
            else -> others.add(note)
        }
    }

    val releaseNote = """
Install & Run: http://docs.vaticle.com/docs/running-typedb/install-and-run

## New Features
${features.map { feature -> createCommitNote(feature) }.joinToString("\n")}

## Bugs Fixed
${bugs.map { bug -> createCommitNote(bug) }.joinToString("\n")}

## Code Refactor
${refactors.map { refactor -> createCommitNote(refactor) }.joinToString("\n")}

## Other Improvements
${others.map { other -> createCommitNote(other) }.joinToString("\n")}
    """
    Files.write(releaseTemplateFile, releaseNote.toByteArray(UTF_8))
}

fun main(args: Array<String>) {
    val buildWorkspaceDirEnv = "BUILD_WORKSPACE_DIRECTORY"
    if (System.getenv(buildWorkspaceDirEnv) == null) throw RuntimeException("Not running from within Bazel workspace")
    val workspaceDirectory = System.getenv(buildWorkspaceDirEnv)

    val createTokenEnv = "CREATE_NOTES_TOKEN"
    if (System.getenv(createTokenEnv) == null) throw RuntimeException("$createTokenEnv environment variable is not set")
    val githubToken = System.getenv(createTokenEnv)

    if (args.size != 5) throw RuntimeException("repository, version, commit, and release-template must be supplied")
    val org = args[0]
    val repo = args[1]
    val version = args[2]
    val toBeReleased = args[3]
    val releaseTemplateFile = Paths.get(workspaceDirectory, args[4])
    if (releaseTemplateFile.notExists()) throw RuntimeException("Release template file does not exist")

    println("release repo: $org/$repo")
    println("release commit $toBeReleased")
    val lastRelease = getLastRelease(org, repo, githubToken)
    val commits = getCommits(org, repo, lastRelease, toBeReleased, githubToken)
    val commitNotes = getCommitNotes(org, repo, commits, githubToken)
    createReleaseNote(commitNotes, releaseTemplateFile)
}
