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

bash_script_template_tar = """\
#!/bin/bash
set -ex
mkdir -p $BUILD_WORKSPACE_DIRECTORY/$1
tar -xzf {artifact_location} -C $BUILD_WORKSPACE_DIRECTORY/$1 --strip-components=2

"""

bash_script_template_unzip = """\
#!/bin/bash
set -ex
mkdir -p $BUILD_WORKSPACE_DIRECTORY/$1
tmp_dir=$(mktemp -d)
unzip -qq {artifact_location} -d $tmp_dir
mv -v $tmp_dir/{artifact_unpacked_name}/* $BUILD_WORKSPACE_DIRECTORY/$1/
rm -rf {artifact_unpacked_name}

"""

cmd_script_template_unzip = """\
set DEST_PATH=%BUILD_WORKSPACE_DIRECTORY:/=\\%\\%1
if not exist "%DEST_PATH%" mkdir %DEST_PATH%
7z x -o%DEST_PATH%\\ {artifact_location}
robocopy %DEST_PATH%\\{artifact_unpacked_name} %DEST_PATH% /E /MOVE

"""

def _artifact_extractor_impl(ctx):
    supported_extensions_map = {
        'cmd': {
            'zip': cmd_script_template_unzip
        },
        'bash': {
            'zip': bash_script_template_unzip,
            'tar': bash_script_template_tar,
            'tar.gz': bash_script_template_tar,
            'tgz': bash_script_template_tar,
            'taz': bash_script_template_tar,
            'tar.bz2': bash_script_template_tar,
            'tb2': bash_script_template_tar,
            'tbz': bash_script_template_tar,
            'tbz2': bash_script_template_tar,
            'tz2': bash_script_template_tar,
            'tar.lz': bash_script_template_tar,
            'tar.lzma': bash_script_template_tar,
            'tlz': bash_script_template_tar,
            'tar.lzo': bash_script_template_tar,
            'tar.xz': bash_script_template_tar,
            'txz': bash_script_template_tar,
            'tar.Z': bash_script_template_tar,
            'tar.zst': bash_script_template_tar
        },
    }

    artifact_file = ctx.file.artifact
    artifact_filename = artifact_file.basename
    extraction_method = ctx.attr.extraction_method
    executor = ctx.attr.executor

    supported_extentions = []
    for executor_extentions in supported_extensions_map.values():
        for ext in executor_extentions.keys():
            if ext not in supported_extentions: supported_extentions.append(ext)

    if (extraction_method == 'auto'):
        artifact_extention = None
        for ext in supported_extentions:
            if artifact_filename.rfind(ext) == len(artifact_filename) - len(ext):
                artifact_extention = ext
                target_script_template = supported_extensions_map.get(executor).get(ext)
                artifact_unpacked_name = artifact_filename.replace('.' + ext, '')
                break
        
        if artifact_extention == None:
            fail("Extention [{extention}] is not supported by the artifiact-etractor.".format(extention = artifact_file.extension))
    elif (extraction_method == 'tar'):
        target_script_template = supported_extensions_map.get(executor).get('tar')
    elif (extraction_method == 'unzip'):
        target_script_template = supported_extensions_map.get(executor).get('zip')

    if target_script_template == None:
        fail('Extracting a [{extension}] with [{executor}] is not yet supported by artifact-extractor.'.format(extension=artifact_extention, executor=executor))

    extensions_map = {
        'bash': 'sh',
        'cmd': 'bat'
    }

    artifact_location = artifact_file.short_path
    if executor == 'cmd': artifact_location = artifact_location.replace('/', '\\')

    # Emit the executable shell script.
    script = ctx.actions.declare_file("{name}.{ext}".format(name=ctx.label.name, ext=extensions_map.get(executor)))
    script_content = target_script_template.format(
        artifact_location = artifact_location,
        artifact_unpacked_name = artifact_unpacked_name
    )

    ctx.actions.write(script, script_content, is_executable = True)

    # The datafile must be in the runfiles for the executable to see it.
    runfiles = ctx.runfiles(files = [artifact_file])
    return [DefaultInfo(executable = script, runfiles = runfiles)]

_artifact_extractor = rule(
    implementation = _artifact_extractor_impl,
    attrs = {
        "artifact": attr.label(
            mandatory = True,
            allow_single_file = True,
            doc = "Artifact archive to extract.",
        ),
        "extraction_method": attr.string(
            default = "auto",
            values = ["unzip", "tar", "auto"],
            doc = "the method to use for extracting the artifact."
        ),
        "executor": attr.string(
            default = "bash",
            values = ["bash", "cmd"],
            doc = "the executor to use for running the extraction script."
        )
    },
    executable = True,
)
