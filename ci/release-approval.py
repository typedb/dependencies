#!/usr/bin/env python

from __future__ import print_function

import os
import subprocess as sp
import json
import time
import sys
import hashlib
import hmac


IS_CIRCLE_ENV = os.getenv('CIRCLECI')
if IS_CIRCLE_ENV is None:
    IS_CIRCLE_ENV = False

GRABL_HOST = 'https://grabl.grakn.ai'
if not IS_CIRCLE_ENV:
    GRABL_HOST = 'http://localhost:8000'

git_username = os.getenv('RELEASE_APPROVAL_USERNAME')
if git_username is None:
    raise Exception('Environment variable $RELEASE_APPROVAL_USERNAME is not set!')

git_token = os.getenv('RELEASE_APPROVAL_TOKEN')
if git_token is None:
    raise Exception('Environment variable $RELEASE_APPROVAL_TOKEN is not set!')

def shell_execute(*args, **kwargs):
    with open(os.devnull, 'w') as devnull:
        try:
            output = sp.check_output(*args, stderr=sp.STDOUT, **kwargs)
            if type(output) == bytes:
                output = output.decode()
            return output
        except sp.CalledProcessError as e:
            print('An error occurred when running "' + str(e.cmd) + '". Process exited with code ' + str(
                e.returncode) + ' and message "' + e.output + '"')
            raise e

workflow_id = os.getenv('CIRCLE_WORKFLOW_ID')

grabl_data = {
    'workflow-id': workflow_id,
    'repo': '{}/{}'.format(os.getenv('CIRCLE_PROJECT_USERNAME'), os.getenv('CIRCLE_PROJECT_REPONAME'))
}

grabl_url_new = '{GRABL_HOST}/release/new'.format(GRABL_HOST=GRABL_HOST)
grabl_url_status = '{GRABL_HOST}/release/{commit}/status'.format(GRABL_HOST=GRABL_HOST, commit=workflow_id)

new_release_signature = hmac.new(git_token, json.dumps(grabl_data), hashlib.sha1).hexdigest()
print("Tests have been ran and everything is in a good, releasable state. "
    "It is possible to proceed with the release process. Waiting for approval.")
shell_execute([
    'curl', '--fail', '-X', 'POST', '--data', json.dumps(grabl_data), '-H', 'Content-Type: application/json', '-H', 'X-Hub-Signature: ' + new_release_signature, grabl_url_new
])

status = 'no-status'

while status == 'no-status':
    get_release_status_signature = hmac.new(git_token, '', hashlib.sha1).hexdigest()
    status = shell_execute(['curl', '--fail', '-H', 'X-Hub-Signature: ' + get_release_status_signature, grabl_url_status])

    if status == 'deploy':
        organisation = os.getenv('CIRCLE_PROJECT_USERNAME')
        repository = os.getenv('CIRCLE_PROJECT_REPONAME')
        release_branch = repository + '-release-branch'

        print('Release Approval received! Initiating release workflow ...')
        sp.check_output(['git', 'branch', release_branch, 'HEAD'], cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY"))
        sp.check_output(['git', 'push', '{0}:{1}@github.com/{2}/{3}.git'.format(git_username, git_token, organisation, repository), release_branch], cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY"))
        print('Initiated the release workflow on {0}/{1}:{2}'.format(organisation, repository, release_branch))
        print('You can monitor it at https://circleci.com/gh/{0}/workflows/{1}/tree/{2}'.format(organisation, repository, release_branch))
    elif status == 'do-not-deploy':
        print("This version won't be released as it has been marked 'do-not-deploy' by an administrator")
        break
    elif status == 'timeout':
        print("This version won't be released as the approval has timed out.")
        break

    # print '...' to provide a visual indication that it's waiting for an input
    sys.stdout.write('.')
    sys.stdout.flush()
    time.sleep(1)
