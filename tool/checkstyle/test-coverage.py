#!/usr/bin/env python

#
# Copyright (C) 2021 Grakn Labs
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

from __future__ import print_function
import tool.common.common as tc
import os
import sys
from xml.etree import ElementTree


def try_decode(s):
    if type(s) == bytes:
        return s.decode()
    return s


if __name__ == '__main__':
    print('Checking if there are any workspace files not covered by checkstyle...')

    workspace_files, _ = tc.shell_execute([
        'find', '.',
            '(', '-name', '.git',
            '-o', '-name', '.idea',
            '-o', '-name', '.ijwb',
            '-o', '-name', '.github',
            '-o', '-name', '.bazelversion',
            '-o', '-name', '.gitkeep',
            '-o', '-name', 'VERSION',
            '-o', '-name', '*.md',
            '-o', '-name', 'node_modules',
        ')', '-prune', '-o', '-type', 'f', '-print'
    ], cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY"))
    workspace_files = workspace_files.split()

    checkstyle_targets_xml, _ = tc.shell_execute([
        'bazel', 'query', 'kind(checkstyle_test, //...)', '--output', 'xml'
    ], cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY"))
    checkstyle_targets_tree = ElementTree.fromstring(checkstyle_targets_xml)
    included_checkstyle_files = checkstyle_targets_tree.findall(".//list[@name='include']//label[@value]")
    excluded_checkstyle_files = checkstyle_targets_tree.findall(".//list[@name='exclude']//label[@value]")
    # examples:
    # - '//test/behaviour:BUILD' transforms to './test/behaviour/BUILD'
    # - '//:README.md' transforms to './README.md'
    checkstyle_files = list(map(lambda x: x.get('value').replace('//:', './').replace('//', './').replace(':', '/'), included_checkstyle_files + excluded_checkstyle_files))
    unique_included_checkstyle_files = set(included_checkstyle_files)
    unique_excluded_checkstyle_files = set(excluded_checkstyle_files)

    if len(unique_included_checkstyle_files) != len(included_checkstyle_files):
        non_unique_checkstyle_file = set([x for x in included_checkstyle_files if included_checkstyle_files.count(x) > 1])
        non_unique_checkstyle_file_count = len(non_unique_checkstyle_file)
        print('ERROR: Found %d workspace files which are included more than once:' % non_unique_checkstyle_file_count)
        for i, target_label in enumerate(non_unique_checkstyle_file, start=1):
            print('%d: %s' % (i, target_label))
        sys.exit(1)

    if len(unique_excluded_checkstyle_files) != len(excluded_checkstyle_files):
        non_unique_checkstyle_file = set([x for x in excluded_checkstyle_files if excluded_checkstyle_files.count(x) > 1])
        non_unique_checkstyle_file_count = len(non_unique_checkstyle_file)
        print('ERROR: Found %d workspace files which are excluded more than once:' % non_unique_checkstyle_file_count)
        for i, target_label in enumerate(non_unique_checkstyle_file, start=1):
            print('%d: %s' % (i, target_label))
        sys.exit(1)

    workspace_files_with_no_checkstyle = set(workspace_files) - set(checkstyle_files)
    file_count = len(workspace_files_with_no_checkstyle)

    if workspace_files_with_no_checkstyle:
        print('ERROR: Found %d workspace files which are not covered by a `checkstyle_test`. They must be placed in either `include` or `exclude` in a `checkstyle_test`.' % file_count)
        for i, file_label in enumerate(workspace_files_with_no_checkstyle, start=1):
            print('%d: %s' % (i, file_label))
        sys.exit(1)

    print('SUCCESS: Every workspace file is covered by a `checkstyle_test`!')
