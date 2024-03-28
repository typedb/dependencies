# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@vaticle_bazel_distribution//artifact:rules.bzl", "artifact_file")

platform_extension = {
    "linux-arm64": "tar.gz",
    "linux-x86_64": "tar.gz",
    "mac-arm64": "zip",
    "mac-x86_64": "zip",
    "windows-x86_64": "zip",
}

def native_artifact_files(name, artifact_name, group_name, **kwargs):
    for platform, ext in platform_extension.items():
        artifact_file(
            name = name + "_" + platform,
            group_name = group_name.replace("{platform}", platform).replace("{ext}", ext),
            # Can't use .format() because the result string will still have the unresolved parameter {version}
            artifact_name = artifact_name.replace("{platform}", platform).replace("{ext}", ext),
            **kwargs,
        )


def artifact_repackage(name, srcs, files_to_keep):
    native.genrule(
        name = name,
        outs = ["{}.tar.gz".format(name)],
        srcs = srcs,
        cmd = "$(location @vaticle_dependencies//distribution/artifact:artifact-repackage) $< $@ {}".format(
            "|".join(files_to_keep)
        ),
        tools = ["@vaticle_dependencies//distribution/artifact:artifact-repackage"]
    )
