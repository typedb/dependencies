#!/usr/bin/env python3

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

import argparse
import os
import platform
import subprocess
from collections import defaultdict
import re

parser = argparse.ArgumentParser()
parser.add_argument('mode', help="Operational mode", choices=['list', 'remove'])
args = parser.parse_args()


BUILDOZER_PATTERN = re.compile("buildozer 'remove deps (?P<dep>.*)' (?P<target>.*)")

UNUSED_DEPS_BINARIES = {
    "Darwin": os.path.abspath("external/unused_deps_mac/file/downloaded"),
    "Linux": os.path.abspath("external/unused_deps_linux/file/downloaded"),
}

BUILDOZER_BINARIES = {
    "Darwin": os.path.abspath("external/buildozer_mac/file/downloaded"),
    "Linux": os.path.abspath("external/buildozer_linux/file/downloaded"),
}

system = platform.system()

if system not in UNUSED_DEPS_BINARIES:
    raise ValueError('unused_deps does not have binary for {}'.format(system))

if system not in BUILDOZER_BINARIES:
    raise ValueError('buildozer does not have binary for {}'.format(system))


output = subprocess.check_output([
    UNUSED_DEPS_BINARIES[system]
], cwd=os.getenv('BUILD_WORKSPACE_DIRECTORY'), stderr=subprocess.STDOUT).decode()

unused_deps = defaultdict(set)

output_lines = output.split('\n')
buildozer_commands = []
for line in output_lines:
    match = BUILDOZER_PATTERN.match(line)
    if match:
        buildozer_commands.append(line)
        gd = match.groupdict()
        unused_deps[gd['target']].add(gd['dep'])


if args.mode == 'list':
    if unused_deps:
        print('\033[0;31mERROR: There are unused deps found:\033[0m')
        for target, deps in unused_deps.items():
            print('{}:'.format(target))
            for dep in deps:
                print('--> {}'.format(dep))
        print('You can run "bazel run @graknlabs_build_tools//unused_deps -- remove" to fix it')
        exit(1)
    else:
        print('\033[0;32mThere are no unused deps found.\033[0m')
elif args.mode == 'remove':
    for cmd in buildozer_commands:
        subprocess.check_call([
            cmd.replace('buildozer', BUILDOZER_BINARIES[system])
        ], shell=True, cwd=os.getenv('BUILD_WORKSPACE_DIRECTORY'))
