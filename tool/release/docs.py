import os
import sys
import subprocess as sp


if os.environ['RELEASE_DOCS_USERNAME'] is None:
    raise Exception('Environment variable $RELEASE_DOCS_USERNAME is not set!')

if os.environ['RELEASE_DOCS_EMAIL'] is None:
    raise Exception('Environment variable $RELEASE_DOCS_EMAIL is not set!')

if os.environ['RELEASE_DOCS_TOKEN'] is None:
    raise Exception('Environment variable $RELEASE_DOCS_TOKEN is not set!')

git_username = os.environ['RELEASE_DOCS_USERNAME']
git_email = os.environ['RELEASE_DOCS_EMAIL']
git_token = git_username + ":" + os.environ['RELEASE_DOCS_TOKEN']

git_org = "graknlabs"

git_repo = "web-dev"
git_branch = sys.argv[1]

git_submod_repo = "docs"
git_submod_commit = sys.argv[2]

git_remote = "github.com/{0}/{1}.git".format(git_org, git_repo)

git_clone_dir = os.path.join("web-dev")
git_clone_submod_dir = os.path.join(git_clone_dir, "docs")


def short_commit(commit_sha):
    return sp.check_output(['git', 'rev-parse', '--short=7', commit_sha],
                           cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY")).decode().replace('\n', '')

if __name__ == '__main__':
    try:
        print('Starting the process of deploying {0} to {1}:{2}'.format(git_submod_repo, git_repo, git_branch))
        # --recursive clones web-dev as well as the docs submodule
        print('Cloning {0} to {1}'.format(git_remote, git_clone_dir))

        sp.check_call(['rm', '-rf', git_clone_dir])
        sp.check_call(["git", "clone", "--recursive", "https://{0}@{1}"
                      .format(git_token, git_remote), git_clone_dir], stderr=sp.STDOUT)
        sp.check_call(["git", "config", "user.email", git_email], cwd=git_clone_dir)
        sp.check_call(["git", "config", "user.name", git_username], cwd=git_clone_dir)
        sp.check_call(["git", "checkout", git_branch], cwd=git_clone_dir)

        print('Updating submodule {0} HEAD to {1}'.format(git_submod_repo, git_clone_submod_dir))
        sp.check_call(["git", "checkout", git_submod_commit], cwd=git_clone_submod_dir)
        sp.check_call(["git", "add", git_submod_repo], cwd=git_clone_dir)

        # the command returns 1 if there is a staged file. otherwise, it will return 0
        should_commit = sp.call(["git", "diff", "--staged", "--exit-code"], cwd=git_clone_dir) == 1
        if should_commit:
            git_commit_msg = "//ci:release-docs: {0}/{1}@{2}".format(git_org, git_submod_repo, short_commit(git_submod_commit))
            print('Committing {0}:{1} with message {2}'.format(git_repo, git_branch, git_commit_msg))
            sp.check_call(["git", "commit", "-m", git_commit_msg], cwd=git_clone_dir)
            print('Pushing changes to {0}'.format(git_remote))
            sp.check_call(["git", "push", "https://{0}@{1}".format(git_token, git_remote), git_branch], cwd=git_clone_dir)
            print('Done!')
        else:
            print('{0}/{1}:{2} is up-to-date. Nothing to commit.'.format(git_org, git_repo, git_branch))
    except sp.CalledProcessError as e:
        print('Process exited with code ' + str(e.returncode) + ' and message "' + e.output + '"')
        raise e
