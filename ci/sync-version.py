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

import sys
import logging

logger = logging.getLogger(__name__)
logging.basicConfig(
    format='[%(asctime)s.%(msecs)03d]: %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
)
logger.level = logging.DEBUG

if len(sys.argv) != 2:
    raise Exception('Should pass version file as first argument')

version = None
version_fn = sys.argv[1]

with open(version_fn) as version_file:
    version = version_file.read().strip().split('.')

if len(version) != 3:
    raise Exception('Version file should be in the following format: \'x.y.z\'')

logger.debug('Read version %s from version file %s', '.'.join(version), version_fn)
# bump patch version
version = '.'.join(*((x, y, str(int(z) + 1)) for x, y, z in [version]))
logger.debug('Writing back version %s into version file %s', version, version_fn)

with open(version_fn, 'w') as version_file:
    version_file.write(version)
    version_file.write('\n')
