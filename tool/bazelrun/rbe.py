#!/usr/bin/env python

#
# Copyright (C) 2020 Grakn Labs
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

import os
import platform
import sys
import subprocess as sp

os.chdir(os.getenv('BUILD_WORKSPACE_DIRECTORY'))


def add_rbe_param(cmd):
    if 'run' in cmd:
        if '--' in cmd:
            return cmd.replace('--', '--config=rbe --')
        else:
            raise ValueError('bazel run commands should contain two dashes (--) to separate arguments')
    else:
        return '{} --config=rbe'.format(cmd)


command = ' '.join(sys.argv[1:])
is_linux = platform.system() == 'Linux'

if is_linux and os.path.isfile('/opt/credentials/buildbuddy-cert.pem') and os.path.isfile('/opt/credentials/buildbuddy-key.pem'):
    print('Bazel will be executed with RBE support. '
          'This means the build is remotely executed '
          'and the cache will be re-used by subsequent CI jobs.')
    command = add_rbe_param(command)
else:
    print('Bazel will be executed locally (without RBE support).')

sp.check_call(command.split())
