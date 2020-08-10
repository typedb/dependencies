import os
import sys

if __name__ == '__main__':
    print('Further usage of this script is discouraged. Please use release_validate_deps_test from //ci:rules.bzl instead')
    deps_path = os.path.join('dependencies', 'graknlabs', 'repositories.bzl')
    snapshot_dependencies = []
    with open(os.path.join(os.getenv("BUILD_WORKSPACE_DIRECTORY"), deps_path)) as deps_file_object:
        deps_content = deps_file_object.read().splitlines()
        for arg in sys.argv[1:]:
            dependency = list(filter(lambda line: line.endswith('@' + arg), deps_content))
            if len(dependency) == 1:
                depend_by_tag = dependency[0].strip().startswith('tag')
                if not depend_by_tag:
                    snapshot_dependencies.append(arg)
            else:
                raise RuntimeError('Invalid sync-marker found for {}. '
                                   'There is supposed to be exactly one sync-marker '
                                   'but {} occurrences found.'.format(arg, len(dependency)))
    if len(snapshot_dependencies) == 0:
        print('This commit is releasable because the dependencies are '
              'all released dependencies: {}'.format(sys.argv[1:]))
    else:
        raise RuntimeError('This commit is not releasable because '
                           'there are one or more snapshot dependencies: {}. '
                           'Check that every dependencies listed in {} are all released dependencies '
                           '(ie., depends on a tag instead of a commit).'
                           .format(snapshot_dependencies, deps_path))
