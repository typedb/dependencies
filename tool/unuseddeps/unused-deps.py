#!/usr/bin/env python3
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

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
        print('You can run "bazel run @vaticle_dependencies//tool/unuseddeps:unused-deps -- remove" to fix it')
        exit(1)
    else:
        print('\033[0;32mThere are no unused deps found.\033[0m')
elif args.mode == 'remove':
    for cmd in buildozer_commands:
        subprocess.check_call([
            cmd.replace('buildozer', BUILDOZER_BINARIES[system])
        ], shell=True, cwd=os.getenv('BUILD_WORKSPACE_DIRECTORY'))
