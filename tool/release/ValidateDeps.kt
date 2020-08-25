package tool.release

import com.eclipsesource.json.Json
import java.io.FileReader
import java.nio.file.Paths

fun main() {
    val workspaceRefsPath = "{workspace_refs_json_path}"
    val taggedDeps = "{tagged_deps}"

    val taggedDepsSet = taggedDeps.split(",").toSet()
    val malformedDepsSet = taggedDepsSet.filter { dep -> !dep.startsWith("@") }
    if (malformedDepsSet.isNotEmpty()) {
        System.err.println("\nThe following dependencies do not start with an '@': $malformedDepsSet")
        System.err.println("Please prefix them with '@', ie., ${malformedDepsSet.map { dep -> "@" + dep }}'")
        System.exit(1)
    }

    val refs = Paths.get(workspaceRefsPath)
    val refFileReader = FileReader(refs.toFile())
    val parsed = Json.parse(refFileReader).asObject()

    val taggedDepsFromRefs = parsed["tags"].asObject().names().toSet()
    val snapshotDependencies = taggedDepsSet
            .map { w -> w.replace("@", "") }
            .subtract(taggedDepsFromRefs)

    if (snapshotDependencies.size > 0) {
        System.err.println("\nThese dependencies are expected to be declared by tag instead of commit: $snapshotDependencies")
        System.exit(1)
    }
}
