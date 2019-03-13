#!/usr/bin/env python

"""
dependency_update updates bazel dependencies declared in WORKSPACE

Example usage:
sync_dependencies.py --source client-python:development --targets docs:development-client-python
"""

from __future__ import print_function

import json
import os
import re
import subprocess as sp

import argparse
import sys
import tempfile

CMDLINE_PARSER = argparse.ArgumentParser(
    description='Automatic updater for GraknLabs inter-repository dependencies')
# TODO(vmax): support this cmdline argument
CMDLINE_PARSER.add_argument(
    '--dry-run', help='Do not perform any real actions')
CMDLINE_PARSER.add_argument(
    '--source', required=True)
CMDLINE_PARSER.add_argument(
    '--targets', nargs='+', required=True)


def is_building_upstream():
    """ Returns False is running in a forked repo"""
    return 'graknlabs' in os.getenv('CIRCLE_REPOSITORY_URL', '')


def grabl_credential():
    """ Returns credential to access repository on @grabl's behalf """
    if 'GRABL_CREDENTIAL' not in os.environ:
        raise ValueError(
            'building the upstream repo '
            'requires having $GRABL_CREDENTIAL '
            'env variable')
    return 'grabl:{}'.format(os.getenv('GRABL_CREDENTIAL'))


def ensure_configured(fun):
    """ Decorator ensuring git config has been ran already """
    def wrapper(inner_self):
        # pylint: disable=missing-docstring
        if not inner_self.is_configured:
            inner_self.configure()
        return fun(inner_self)
    return wrapper


def ensure_cloned(fun):
    """ Decorator ensuring git clone has been ran already """
    def wrapper(inner_self, *args, **kwargs):
        # pylint: disable=missing-docstring
        if not inner_self.clone_dir:
            inner_self.clone()
        return fun(inner_self, *args, **kwargs)
    return wrapper


def exception_handler(fun):
    """ Decorator printing additional message on CalledProcessError """
    def wrapper(*args, **kwargs):
        # pylint: disable=missing-docstring
        try:
            fun(*args, **kwargs)
        except sp.CalledProcessError as ex:
            print('An error occurred when running {ex.cmd}. '
                  'Process exited with code {ex.returncode} '
                  'and message {ex.output}'.format(ex=ex))
            print()
            raise ex
    return wrapper


class DependencyReplacer(object):
    def replace(self, clone_dir, src):
        pass


class WorkspaceDependencyReplacer(DependencyReplacer):
    COMMIT_HASH_REGEX = r'[0-9a-f]{40}'

    def replace(self, target, source):
        dependencies_file_path = os.path.join(target.clone_dir, 'dependencies', 'graknlabs', 'dependencies.bzl')

        if not os.path.isfile(dependencies_file_path):
            print('Could not find dependencies.bzl file at ' + str(dependencies_file_path.lstrip(target.clone_dir)) +
                  ' in @{tgt.bazel_workspace}'.format(tgt=target))
            print()
            exit(1)

        with open(dependencies_file_path, 'r') as workspace_file:
            workspace_content = workspace_file.readlines()

        for i, line in enumerate(workspace_content):
            if source.marker in line:
                workspace_content[i] = re.sub(self.COMMIT_HASH_REGEX, source.last_commit, line, 1)
                break
        else:
            print('@{tgt.bazel_workspace} has '
                  'no dependency marker of '
                  '@{src.bazel_workspace} to replace'.format(tgt=target, src=source))
            print()
            exit(1)

        with open(dependencies_file_path, 'w') as workspace_file:
            workspace_file.writelines(workspace_content)

        return [dependencies_file_path]


class PackageJsonDependencyReplacer(DependencyReplacer):
    COMMIT_HASH_REGEX = r'[0-9a-f]{40}'

    def find_packagejson_files(self, path):
        packagejson_files = []
        for dirpath, subdirs, files in os.walk(path):
            for x in files:
                if x == "package.json":
                    packagejson_files.append(os.path.join(dirpath, x))
        return packagejson_files

    def replace_singlefile(self, fn, source):
        with open(fn) as package_json_file:
            package_json = json.load(package_json_file)

        grakn_client_link = package_json['dependencies']['grakn-client']
        grakn_client_link = re.sub(self.COMMIT_HASH_REGEX, source.last_commit, grakn_client_link, 1)
        package_json['dependencies']['grakn-client'] = grakn_client_link

        with open(fn, 'w') as package_json_file:
            json.dump(package_json, package_json_file, indent=4)

    def replace(self, target, source):
        packagejson_files = self.find_packagejson_files(target.clone_dir)

        if not packagejson_files:
            print('Could not find any package.json files at {clone_dir}'
                  ' in @{tgt.bazel_workspace}'.format(clone_dir=target.clone_dir, tgt=target))
            print()
            exit(1)

        for fn in packagejson_files:
            self.replace_singlefile(fn, source)

        return packagejson_files


class GitRepo(object):
    """ Encapsulates a git repository @grabl has access to """
    GRAKNLABS_PREFIX = 'graknlabs_'
    GRAKN_CORE_REPO_NAME = 'grakn'
    GRAKN_CORE_WORKSPACE = GRAKNLABS_PREFIX + 'grakn_core'
    GRAKN_AUTHENTICATED_REMOTE_TEMPLATE = 'https://$CREDENTIAL@github.com/graknlabs/{repo}.git'

    # pylint: disable=line-too-long
    SYNC_MARKER = '# sync-marker: do not remove this comment, this is used for sync-dependencies by @{ws_name}'
    CLEAN_TREE_MSG = 'nothing to commit, working tree clean'
    CIRCLECI_GITSHA_ENV_KEY = 'CIRCLE_SHA1'

    GIT_USERNAME = 'Grabl'
    GIT_EMAIL = 'grabl@grakn.ai'

    def __init__(self, git_coordinates):
        coords = git_coordinates.split(':')
        if len(coords) == 1:
            # only repo name was specified, commit is read from environment variable
            self.repo = coords[0]
            if self.CIRCLECI_GITSHA_ENV_KEY not in os.environ:
                raise ValueError(
                    '${} should be set if branch is not specified'.format(
                        self.CIRCLECI_GITSHA_ENV_KEY))
            self._last_commit = os.getenv(self.CIRCLECI_GITSHA_ENV_KEY)
        elif len(coords) == 2:
            self.repo, self.branch = coords
            self._last_commit = None
        else:
            raise ValueError('git coordinates should be in "repo_name" or "repo_name:branch_name" form')
        self.credential = grabl_credential()
        self.credential_env = {'CREDENTIAL': self.credential}
        self.is_configured = False
        self.clone_dir = None

    def __str__(self):
        return 'GitRepo<{}:{}>'.format(self.repo, self.branch)

    @property
    def bazel_workspace(self):
        """ Repository name as bazel workspace name """
        if self.repo == self.GRAKN_CORE_REPO_NAME:
            return self.GRAKN_CORE_WORKSPACE
        return self.GRAKNLABS_PREFIX + self.repo.replace('-', '_')

    @property
    def remote_url(self):
        """ git remote url for authenticated pushing """
        return self.GRAKN_AUTHENTICATED_REMOTE_TEMPLATE.format(repo=self.repo)

    @property
    def marker(self):
        """ reference marker to update """
        return self.SYNC_MARKER.format(ws_name=self.bazel_workspace)

    @property
    def last_commit(self):
        """ latest commit on a branch; result is cached """
        if self._last_commit:
            return self._last_commit
        git_output = sp.check_output([
            'bash', '-c',
            'git ls-remote {} {}'.format(
                self.remote_url,
                self.branch
            )], env=self.credential_env)
        self._last_commit = git_output.split()[0]
        return self._last_commit

    def configure(self):
        """ set username and email for the repo """
        sp.check_output(["git", "config", "--global", "user.email", self.GIT_EMAIL], stderr=sp.STDOUT)
        sp.check_output(["git", "config", "--global", "user.name", self.GIT_USERNAME], stderr=sp.STDOUT)

    @ensure_configured
    def clone(self):
        """ clones git repo to a temp directory and returns it; result is cached"""
        temp_dir = tempfile.mkdtemp('.' + self.repo, 'git.')
        sp.check_call([
            'bash', '-c',
            'git clone {} {}'.format(self.remote_url, temp_dir)
        ], env=self.credential_env)
        sp.check_call([
            'git', 'checkout', self.branch
        ], cwd=temp_dir)
        self.clone_dir = temp_dir
        return self.clone_dir

    @ensure_cloned
    def replace_marker(self, source):
        """ replaces marker with other_repo reference """

        if source.repo == 'client-nodejs':
            replacer = PackageJsonDependencyReplacer()
        else:
            replacer = WorkspaceDependencyReplacer()

        replaced_files = replacer.replace(self, source)

        sp.check_output(['git', 'add'] + replaced_files, cwd=self.clone_dir, stderr=sp.STDOUT)
        should_commit = self.CLEAN_TREE_MSG not in sp.check_output(
            ['git', 'status'], cwd=self.clone_dir, env={
                'LANG': 'C'
            })

        if not should_commit:
            print('@{tgt.bazel_workspace} already depends on @{src.bazel_workspace} at commit {src.last_commit}'.format(
                tgt=self, src=source
            ))
            print()
            return

        sp.check_output(['git', 'commit', '-m',
                         "Update @{src.bazel_workspace} dependency to latest '{src.branch}' branch".format(src=source)],
                        cwd=self.clone_dir,
                        stderr=sp.STDOUT)
        print('Pushing the change to {tgt.repo} ({tgt.branch} branch)'.format(tgt=self))

        sp.check_output(['bash', '-c', 'git push {} {}'.format(self.remote_url, self.branch)],
                        env=self.credential_env, cwd=self.clone_dir, stderr=sp.STDOUT)
        print('The change has been pushed to {tgt.repo} ({tgt.branch} branch)'.format(tgt=self))
        print()


@exception_handler
def main():
    """ main loop """
    if not is_building_upstream():
        print('Not building the upstream repo, no need to update the docs')
        exit(0)

    # ensure that credential is present
    grabl_credential()

    arguments = CMDLINE_PARSER.parse_args(sys.argv[1:])

    source = GitRepo(arguments.source)
    targets = list(map(GitRepo, arguments.targets))

    print('** This will make these repos depend on the latest '
          '{src.repo} ({src.branch} branch) '.format(src=source))
    for target in targets:
        print('\t * {tgt.repo} ({tgt.branch} branch)'.format(tgt=target))

    print('The latest commit in @{src.bazel_workspace} is {src.last_commit}'.format(src=source))
    for target in targets:
        print('{tgt} cloned to {clone}'.format(tgt=target, clone=target.clone()))
        target.replace_marker(source)


if __name__ == '__main__':
    main()
