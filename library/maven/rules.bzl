load("@rules_jvm_external//:defs.bzl", rje_maven_install = "maven_install")
load("@rules_jvm_external//:specs.bzl", rje_maven = "maven")
load(":artifacts.bzl", maven_artifacts_org = "artifacts")

def maven(artifacts_org, artifacts_repo={}):
    if len(artifacts_repo) > 0:
        _warn("There are {} artifacts_repo found. Overriding artifacts_org with `artifacts_repo` is discouraged!".format(len(artifacts_repo)))
    for a in artifacts_org:
        if a not in maven_artifacts_org.keys():
            fail("'" + a + "' has not been declared in @graknlabs_dependencies")
    artifacts_selected = []
    for a in artifacts_org:
        artifact = maven_artifact(a, artifacts_repo.get(a, maven_artifacts_org[a]))
        artifacts_selected.append(artifact)
    rje_maven_install(
        artifacts = artifacts_selected,
        repositories = [
            "https://repo1.maven.org/maven2",
            "https://repo.grakn.ai/repository/maven",
            "https://repo.grakn.ai/repository/maven-snapshot",
        ],
        strict_visibility = True,
        version_conflict_policy = "pinned"
    )

def maven_artifact(artifact, artifact_info):
    group, artifact_id = artifact.split(':')
    if type(artifact_info) == type(' '):
        artifact = rje_maven.artifact(
            group = group,
            artifact = artifact_id,
            version = artifact_info,
        )
    elif type(artifact_info) == type({}):
        exclusions = []
        for e in artifact_info['exclude']:
            exclusions.append(e)
        artifact = rje_maven.artifact(
            group = group,
            artifact = artifact_id,
            version = artifact_info['version'],
            exclusions = exclusions
        )
    else:
        fail("The info for '" + artifact + "' must either be a 'string' (eg., '1.8.1') or a 'dict' (eg., {'version': '1.8.1', 'exclude': ['org.slf4j:slf4j']})")
    return artifact

def _warn(msg):
    print('{red}{msg}{nc}'.format(red='\033[0;31m', msg=msg, nc='\033[0m'))
