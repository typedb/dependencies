load("@rules_jvm_external//:defs.bzl", "maven_install")
load(":artifacts.bzl", artifacts_registered = "artifacts")

def maven(artifacts_list):
    deduplicate = {}
    for artifact in artifacts_list:
        deduplicate[artifact] = True
    artifacts_list = deduplicate.keys()
    for artifact in artifacts_list:
        if artifact not in artifacts_registered.keys():
            fail("'" + artifact + "' has not been declared in @graknlabs_dependencies")
    artifacts_selected = []
    for key in artifacts_registered.keys():
        if key in artifacts_list:
            artifact_id = key
            version = artifacts_registered[key]
            artifacts_selected.append(artifact_id + ":" + version)
    maven_install(
        artifacts = artifacts_selected,
        repositories = [
            "https://repo1.maven.org/maven2",
            "http://maven.grakn.ai/nexus/content/repositories/snapshots"
        ],
        strict_visibility = True,
        version_conflict_policy = "pinned"
    )
