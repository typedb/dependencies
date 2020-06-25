load("@rules_jvm_external//:defs.bzl", "maven_install")
load(":artifacts.bzl", "artifacts")

def maven(selections):
    deduplicate = {}
    for selection in selections:
        deduplicate[selection] = True
    selections = deduplicate.keys()
    for selection in selections:
        if selection not in artifacts.keys():
            fail("'" + selection + "' has not been declared in @graknlabs_dependencies")
    selected = []
    for key in artifacts.keys():
        if key in selections:
            artifact_id = key
            version = artifacts[key]
            selected.append(artifact_id + ":" + version)
    maven_install(
        artifacts = selected,
        repositories = [
            "https://repo1.maven.org/maven2",
            "http://maven.grakn.ai/nexus/content/repositories/snapshots"
        ],
        strict_visibility = True,
        version_conflict_policy = "pinned"
    )
