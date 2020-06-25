load("@rules_jvm_external//:defs.bzl", "maven_install")
load(":artifacts.bzl", artifacts_registered = "artifacts")

def maven(artifacts_list):
    for artifact in artifacts_list:
        if artifact not in artifacts_registered.keys():
            fail("'" + artifact + "' has not been declared in @graknlabs_dependencies")
    artifacts_selected = []
    for artifact in artifacts_list:
        version = artifacts_registered[artifact]
        artifacts_selected.append(artifact + ":" + version)
    maven_install(
        artifacts = artifacts_selected,
        repositories = [
            "https://repo1.maven.org/maven2",
            "http://maven.grakn.ai/nexus/content/repositories/snapshots"
        ],
        strict_visibility = True,
        version_conflict_policy = "pinned"
    )
