#!/usr/bin/env python

#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2018 Grakn Labs Ltd
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

import argparse
import hashlib
import hmac
import json
import logging
import os
import subprocess
import sys

CMDLINE_PARSER = argparse.ArgumentParser()
CMDLINE_PARSER.add_argument('--file', required=True)

CMDLINE_GROUP_PARSER = CMDLINE_PARSER.add_mutually_exclusive_group(required=True)
CMDLINE_GROUP_PARSER.add_argument('--get', dest='get', action='store_true')
CMDLINE_GROUP_PARSER.add_argument('--save-success', dest='store', action='store_true')
CMDLINE_GROUP_PARSER.set_defaults(store=None)

git_token = os.getenv('RELEASE_APPROVAL_TOKEN')

if not git_token:
    raise Exception('Environment variable $RELEASE_APPROVAL_TOKEN is not set!')

if not os.getenv('CIRCLE_SHA1'):
    raise Exception('Environment variable $CIRCLE_SHA1 is not set!')

if not os.getenv('CIRCLE_BUILD_URL'):
    raise Exception('Environment variable $CIRCLE_BUILD_URL is not set!')


logger = logging.getLogger(__name__)
logging.basicConfig(
    format='[%(asctime)s.%(msecs)03d]: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
)
logger.level = logging.DEBUG


def check_output_discarding_stderr(*args, **kwargs):
    with open(os.devnull, 'w') as devnull:
        try:
            output = subprocess.check_output(*args, stderr=devnull, **kwargs)
            if type(output) == bytes:
                output = output.decode()
            return output
        except subprocess.CalledProcessError as e:
            print('An error occurred when running "' + str(e.cmd) + '". Process exited with code ' + str(
                e.returncode) + ' and message "' + e.output + '"')
            raise e


args = CMDLINE_PARSER.parse_args(sys.argv[1:])
file_checksum = hashlib.sha256(open(args.file, 'rb').read()).hexdigest()

if args.get:
    response = json.loads(check_output_discarding_stderr([
        'curl',
        'https://grabl.grakn.ai/ci/distribution/{}'.format(file_checksum)
    ]))
    if response.get('result'):
        logger.debug('Cache from run [%s] (commit %s)'
                     'indicates the test success, '
                     'skipping the actual execution',
                     response.get('commit'),
                     response.get('build_url'))
        subprocess.check_call([
            'circleci',
            'step',
            'halt'
        ])  # finish with success
    else:
        logger.debug('Run has not been cached yet, proceeding with execution')
        exit(0)  # no result yet
elif args.store:
    data = {
        'sha256': file_checksum,
        'result': True,
        'build_url': os.getenv('CIRCLE_BUILD_URL'),
        'commit': os.getenv('CIRCLE_SHA1')
    }
    signature = hmac.new(git_token.encode(), json.dumps(data).encode(), hashlib.sha1).hexdigest()

    check_output_discarding_stderr([
        'curl',
        '--fail',
        '-X',
        'POST',
        '--data',
        json.dumps(data),
        '-H',
        'Content-Type: application/json',
        '-H',
        'X-Hub-Signature: ' + signature,
        'https://grabl.grakn.ai/ci/distribution/insert'
    ])

    logger.debug('Cached successful test execution for %s [%s]', args.file, file_checksum)
