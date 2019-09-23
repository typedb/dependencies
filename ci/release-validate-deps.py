import os
import sys

if __name__ == '__main__':
    dependencies_bzl = os.path.join('dependencies', 'graknlabs', 'dependencies.bzl')
    snapshot_dependencies = []
    with open(os.path.join(os.getenv("BUILD_WORKSPACE_DIRECTORY"), dependencies_bzl)) as dependencies_bzl_:
        dependencies_bzl__ = dependencies_bzl_.read().splitlines()
        for arg in sys.argv[1:]:
            dependency = filter(lambda line: line.endswith('@' + arg), dependencies_bzl__)
            if len(dependency) == 1:
                depend_by_tag = dependency[0].strip().startswith('tag')
                if not depend_by_tag:
                    snapshot_dependencies.append(arg)
            else:
                raise RuntimeError('Invalid sync-marker found for {}. '
                                   'There is supposed to be exactly one sync-marker '
                                   'but {} occurrences found.'.format(arg, len(dependency)))
    if len(snapshot_dependencies) == 0:
        print('This repository is releasable because the dependencies are '
              'all release dependencies: {}'.format(sys.argv[1:]))
    else:
        raise RuntimeError('Error: This commit is not releasable because '
                           'there are one or more snapshot dependencies: {}. '
                           'Check that every dependencies listed in {} are all release dependencies '
                           '(ie., depends on a tag instead of a commit)'
                           .format(snapshot_dependencies, dependencies_bzl))