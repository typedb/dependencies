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
import glob
import os
import subprocess as sp

parser = argparse.ArgumentParser()
parser.add_argument('--credential', help='Sonarcloud credential', required=True) # TODO(lolski): pass via environment variable for security
parser.add_argument('--project-key', help='Sonarcloud project key', required=True)
parser.add_argument('--organisation', help='Sonarcloud organisation', required=True)
args = parser.parse_args()

tmpdir = None
try:
    tmpdir = sp.check_output(['mktemp', '-d']).strip()
    sp.check_call(['unzip', os.path.join('external', 'sonarscanner_zip', 'file', 'downloaded'), '-d', tmpdir])
    sp.check_call(['mv'] + glob.glob(os.path.join(tmpdir, 'sonar-scanner-*', '*')) + ['.'], cwd=tmpdir)
    sp.check_call([os.path.join(tmpdir, 'bin', 'sonar-scanner'), '-Dsonar.projectKey=' + args.project_key, '-Dsonar.organization=' + args.organisation, '-Dsonar.sources=.', '-Dsonar.java.binaries=.', '-Dsonar.java.libraries=.', '-Dsonar.host.url=https://sonarcloud.io', '-Dsonar.login=' + args.credential], cwd=os.getenv('BUILD_WORKSPACE_DIRECTORY'))
finally:
    # sp.check_call(['rm', '-rf', tmpdir]) # TODO(lolski): delete directory
    pass