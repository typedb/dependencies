#!/usr/bin/env python
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


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
parser.add_argument('--coverage-reports', help='location of JaCoCo XML coverage reports')
args = parser.parse_args()

tmpdir = None
try:
    tmpdir = tempfile.mkdtemp()
    sp.check_call(['unzip', '-qq',
        os.path.join(glob.glob(os.path.join('external', 'sonarscanner_*_zip'))[0], 'file', 'downloaded'), '-d', tmpdir])
    sp.check_call(['mv'] + glob.glob(os.path.join(tmpdir, 'sonar-scanner-*', '*')) + ['.'], cwd=tmpdir)
    cmd=os.path.join(tmpdir, 'bin', 'sonar-scanner') + \
        ' -Dsonar.projectKey=' + args.project_key + \
        ' -Dsonar.organization=' + args.organisation + \
        ' -Dsonar.projectVersion=' + args.commit_id + \
        ' -Dsonar.branch.name=' + args.branch + \
        ' -Dsonar.sources=. -Dsonar.java.binaries=. ' + \
        ' -Dsonar.java.libraries=.' + \
        ' -Dsonar.plugins.downloadOnlyRequired=true' + \
        ' -Dsonar.host.url=https://sonarcloud.io' + \
        ' -Dsonar.token=$SONARCLOUD_CODE_ANALYSIS_CREDENTIAL'
    if args.coverage_reports is not None:
        cmd = cmd + ' -Dsonar.coverage.jacoco.xmlReportPaths=' + args.coverage_reports
    sp.check_call(cmd, cwd=os.getenv('BUILD_WORKSPACE_DIRECTORY'), shell=True)
finally:
    shutil.rmtree(tmpdir)
