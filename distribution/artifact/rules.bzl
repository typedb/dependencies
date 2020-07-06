#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

GRAKNLABS_ARTIFACT_RELEASE_REPOSITORY_URL = "https://repo.grakn.ai/repository/artifact"
GRAKNLABS_ARTIFACT_SNAPSHOT_REPOSITORY_URL = "https://repo.grakn.ai/repository/artifact-snapshot"

def _deploy_artifact_impl(ctx):
    _deploy_script = ctx.actions.declare_file("{}_deploy.py".format(ctx.attr.name))

    version_file = ctx.actions.declare_file(ctx.attr.name + "__do_not_reference.version")
    version = ctx.var.get('version', '0.0.0')

    ctx.actions.run_shell(
        inputs = [],
        outputs = [version_file],
        command = "echo {} > {}".format(version, version_file.path),
    )
    
    ctx.actions.expand_template(
        template = ctx.file._deploy_script,
        output = _deploy_script,
        substitutions = {
            "{version_file}": version_file.short_path,
            "{artifact_path}": ctx.file.target.short_path,
            "{artifact_group}": ctx.attr.artifact_group,
            "{artifact_filename}": ctx.attr.artifact_name,
            "{release_repository_url}": ctx.attr.release_repository_url,
            "{snapshot_repository_url}": ctx.attr.snapshot_repository_url,
        },
    )
    files = [
        ctx.file.target,
        version_file,
        ctx.file._common_py
    ]

    symlinks = {
        "common.py": ctx.file._common_py,
        'VERSION': version_file,
    }

    return DefaultInfo(
        executable = _deploy_script,
        runfiles = ctx.runfiles(
            files = files,
            symlinks = symlinks,
        ),
    )


deploy_artifact = rule(
    attrs = {
        "target": attr.label(
            allow_single_file = True,
            mandatory = True,
            doc = "File to deploy to repo",
        ),
        "version_file": attr.label(
            allow_single_file = True,
            doc = """
            File containing version string.
            Alternatively, pass --define version=VERSION to Bazel invocation.
            Not specifying version at all defaults to '0.0.0'
            """,
        ),
        "artifact_group": attr.string(
            mandatory = True,
            doc = "The group of the artifact.",
        ),
        "artifact_name": attr.string(
            doc = "The artifact filename, automatic from the target file if not specified",
            default = '',
        ),
        "_deploy_script": attr.label(
            allow_single_file = True,
            default = "//distribution/artifact/templates:deploy.py",
        ),
        "_common_py": attr.label(
            allow_single_file = True,
            default = "@graknlabs_bazel_distribution//common:common.py",
        ),
        "release_repository_url": attr.string(
            default = GRAKNLABS_ARTIFACT_RELEASE_REPOSITORY_URL,
        ),
        "snapshot_repository_url": attr.string(
            default = GRAKNLABS_ARTIFACT_SNAPSHOT_REPOSITORY_URL,
        ),
    },
    executable = True,
    implementation = _deploy_artifact_impl,
    doc = "Deploy archive target into a raw repo",
)


def artifact_file(name,
                  group_name,
                  artifact_name,
                  downloaded_file_path = None,
                  commit = None,
                  tag = None,
                  sha = None,
                  release_repository_url = GRAKNLABS_ARTIFACT_RELEASE_REPOSITORY_URL,
                  snapshot_repository_url = GRAKNLABS_ARTIFACT_SNAPSHOT_REPOSITORY_URL,
                  tags = []):
    """Macro to assist depending on a deployed artifact by generating urls for http_file.

    Args:
        name: Target name.
        group_name: Repo group name used to deploy artifact.
        artifact_name: Artifact name, use {version} to interpolate the version from tag/commit.
        downloaded_file_path: Equivalent to http_file downloaded_file_path, defaults to artifact_name, includes {version} interpolation.
        commit: Commit sha, for when this was used as the version for upload.
        tag: Git tag, for when this was used as the version for upload.
        release_repository_url: The base repository URL for tag releases.
        snapshot_repository_url: The base repository URL for snapshot/commit sha releases.
        tags: Tags to forward onto the http_file rule.
    """

    version = tag if tag != None else commit
    versiontype = "tag" if tag != None else "commit"

    repository_url = release_repository_url if tag != None else snapshot_repository_url

    if downloaded_file_path == None:
        downloaded_file_path = artifact_name

    artifact_name = artifact_name.format(version = version)
    downloaded_file_path = downloaded_file_path.format(version = version)

    http_file(
        name = name,
        urls = ["{}/{}/{}/{}".format(repository_url, group_name, version, artifact_name)],
        downloaded_file_path = artifact_name,
        sha = sha,
        tags = tags + ["{}={}".format(versiontype, version)]
    )
