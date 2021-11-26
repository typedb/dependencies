package com.vaticle.dependencies.tool.release.deps

import com.eclipsesource.json.Json
import com.google.api.client.http.GenericUrl
import com.google.api.client.http.javanet.NetHttpTransport
import java.io.FileReader
import java.nio.file.Paths
import java.util.regex.Pattern


fun httpGet(url: String?) {
    NetHttpTransport()
            .createRequestFactory()
            .buildGetRequest(GenericUrl(url))
            .execute();
}


fun main(args: Array<String>) {
    @Suppress("NAME_SHADOWING") val args = args.toMutableList()
    val refs = Paths.get(args.removeAt(0))
    val refFileReader = FileReader(refs.toFile())
    val parsed = Json.parse(refFileReader).asObject()

    val versionRegex = Pattern.compile("^[0-9]+.[0-9]+.[0-9]+(-[-a-zA-Z0-9]+)?$")
    val npmjsAddress = "https://registry.npmjs.org/%s/-/%s-%s.tgz"

    args.forEach {
        val version = parsed.get("dependencies").asObject().getString(it, null)
                ?: throw RuntimeException("dependency is not present in package.json: $it")

        if (!versionRegex.matcher(version).matches()) {
            throw RuntimeException("invalid version of $it: $version")
        }

        val url = npmjsAddress.format(it, it, version)
        try {
            httpGet(url)
        } catch (e: Exception) {
            throw RuntimeException("cannot download version $version of $it (url $url); please ensure it has been released to npmjs.org")
        }
    }

}
