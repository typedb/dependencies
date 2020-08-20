package tool.release

import com.eclipsesource.json.Json
import java.io.FileReader
import java.nio.file.Paths

fun main() {
    val workspaceRefsPath = "{workspace_refs_json_path}"
    val taggedDeps = "{tagged_deps}"

    val refs = Paths.get(workspaceRefsPath)
    val refFileReader = FileReader(refs.toFile())
    val parsed = Json.parse(refFileReader).asObject()

    val taggedDepsSet = taggedDeps.split(",").toSet().map { w -> w.replace("@", "") }

    val tagDepsFromRefs = parsed["tags"].asObject().names().toSet()
    val snapshotDependencies = taggedDepsSet.subtract(tagDepsFromRefs)

    if (snapshotDependencies.size > 0) {
        System.err.println("\nThese dependencies are expected to be declared by tag instead of commit: $snapshotDependencies")
        System.exit(1)
    }
}
