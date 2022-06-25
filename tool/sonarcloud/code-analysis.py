#!/usr/bin/env python

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

import argparse
import glob
import os
import shutil
import subprocess as sp
import tempfile

credential = os.getenv('SONARCLOUD_CODE_ANALYSIS_CREDENTIAL')
if not credential:
    raise Exception('$SONARCLOUD_CODE_ANALYSIS_CREDENTIAL must be defined')

parser = argparse.ArgumentParser()
parser.add_argument('--project-key', help='Sonarcloud project key', required=True)
parser.add_argument('--organisation', help='Sonarcloud organisation', default='vaticle')
parser.add_argument('--commit-id', help='git commit id', required=True)
parser.add_argument('--branch', help='git branch name', required=True)
args = parser.parse_args()

tmpdir = None
try:
    tmpdir = tempfile.mkdtemp()
    sp.check_call(['unzip', '-qq',
        os.path.join('external', 'sonarscanner_zip', 'file', 'downloaded'), '-d', tmpdir])
    sp.check_call(['mv'] + glob.glob(os.path.join(tmpdir, 'sonar-scanner-*', '*')) + ['.'], cwd=tmpdir)
    sp.check_call(
        os.path.join(tmpdir, 'bin', 'sonar-scanner') + \
            ' -Dsonar.projectKey=' + args.project_key + \
            ' -Dsonar.organization=' + args.organisation + \
            ' -Dsonar.projectVersion=' + args.commit_id + \
            ' -Dsonar.branch.name=' + args.branch + \
            ' -Dsonar.sources=. -Dsonar.java.binaries=. ' + \
            ' -Dsonar.java.libraries=.' + \
            ' -Dsonar.host.url=https://sonarcloud.io' + \
            ' -Dsonar.login=$SONARCLOUD_CODE_ANALYSIS_CREDENTIAL',
        cwd=os.getenv('BUILD_WORKSPACE_DIRECTORY'), shell=True)
finally:
    shutil.rmtree(tmpdir)
