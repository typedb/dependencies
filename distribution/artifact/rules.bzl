#
# Copyright (C) 2022 Vaticle
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

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
