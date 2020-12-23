load("@graknlabs_bazel_distribution//artifact:rules.bzl", "artifact_file")

def native_artifact_files(name, artifact_name, **kwargs):
    for platform, ext in [("mac", "zip"), ("linux", "tar.gz"), ("windows", "zip")]:
        artifact_file(
            name = name + "_" + platform,
            # Can't use .format() because the result string will still have the unresolved parameter {version}
            artifact_name = artifact_name.replace("{platform}", platform).replace("{ext}", ext),
            **kwargs,
        )
