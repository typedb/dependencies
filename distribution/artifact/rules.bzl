load("@graknlabs_bazel_distribution//artifact:rules.bzl", "artifact_file")

def native_artifact_files(name, artifact_name, **kwargs):
    platforms = ["mac", "linux"]
    for platform in platforms:
        artifact_file(
            name = name + "_" + platform,
            # Can't use .format() because the result string will still have the unresolved parameter {version}
            artifact_name = artifact_name.replace("{platform}", platform),
            **kwargs,
        )
