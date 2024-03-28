/*
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at https://mozilla.org/MPL/2.0/.
 */

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

    val packageVersion = File(args.removeAt(0)).readText().trim()
    val isRcAllowed = packageVersion.lowercase().contains("rc")

    val versionRegex = Pattern.compile("^[0-9]+.[0-9]+.[0-9]+(-[-a-zA-Z0-9]+)?$")
    val npmjsAddress = "https://registry.npmjs.org/%s/-/%s-%s.tgz"

    args.forEach {
        val version = parsed.get("dependencies").asObject().getString(it, null)
                ?: throw RuntimeException("dependency is not present in package.json: $it")

        if (!versionRegex.matcher(version).matches()) {
            throw RuntimeException("invalid version of $it: $version")
        }

        if (!isRcAllowed && version.lowercase().contains("rc")) {
            throw RuntimeException("RC dependency $it: $version not allowed for non-RC release $packageVersion")
        }

        val url = npmjsAddress.format(it, it, version)
        try {
            httpGet(url)
        } catch (e: Exception) {
            throw RuntimeException("cannot download version $version of $it (url $url); please ensure it has been released to npmjs.org")
        }
    }

}
