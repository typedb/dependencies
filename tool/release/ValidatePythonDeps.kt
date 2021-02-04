package tool.release

import com.eclipsesource.json.Json
import com.eclipsesource.json.JsonObject
import com.google.api.client.http.GenericUrl
import com.google.api.client.http.javanet.NetHttpTransport
import java.io.FileReader
import java.nio.file.Files
import java.nio.file.Paths
import java.util.regex.Pattern


fun httpGetJson(url: String?): JsonObject {
    return Json.parse(NetHttpTransport()
            .createRequestFactory()
            .buildGetRequest(GenericUrl(url))
            .execute()
            .parseAsString()).asObject()
}


fun main(args: Array<String>) {
    @Suppress("NAME_SHADOWING") val args = args.toMutableList()
    val requirements = Files.readAllLines(Paths.get(args.removeAt(0))).filter {
        !it.startsWith("#") && !it.startsWith("--") && it.trim().isNotBlank()
    }.associate {
        val items = it.replace(">=", "==").split("==")
        items[0] to items[1]
    }

    val versionRegex = Pattern.compile("^(\\d+!)?(\\d+)(\\.\\d+)+(a((\\d+)+)?)?\$")
    val pypiAddress = "https://pypi.org/pypi/%s/json"

    args.forEach {
        val version = requirements.get(it)
                ?: throw RuntimeException("dependency is not present in requirements.txt: $it")

        if (!versionRegex.matcher(version).matches()) {
            throw RuntimeException("invalid version of $it: $version")
        }

        val url = pypiAddress.format(it)
        try {
            httpGetJson(url).get("releases").asObject().get(version).asArray()
        } catch (e: Exception) {
            throw RuntimeException("cannot download version $version of $it (url $url); please ensure it has been released to pypi.org")
        }
    }

}
