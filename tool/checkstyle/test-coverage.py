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
    print('Checking if there are any source files not covered by checkstyle...')

    java_targets, _ = tc.shell_execute([
        'bazel', 'query',
        '(kind(java_library, //...) union kind(java_test, //...)) '
        'except //dependencies/... except attr("tags", "checkstyle_ignore", //...)'
    ], cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY"))
    java_targets = java_targets.split()

    checkstyle_targets_xml, _ = tc.shell_execute([
        'bazel', 'query', 'kind(checkstyle_test, //...)', '--output', 'xml'
    ], cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY"))
    checkstyle_targets_tree = ElementTree.fromstring(checkstyle_targets_xml)
    java_targets_covered_by_target_attr = checkstyle_targets_tree.findall(".//label[@name='target'][@value]")
    java_targets_covered_by_targets_attr = checkstyle_targets_tree.findall(".//list[@name='targets']//label[@value]")
    checkstyle_targets = list(map(
        lambda x: x.get('value'), java_targets_covered_by_target_attr + java_targets_covered_by_targets_attr))
    unique_checkstyle_targets = set(checkstyle_targets)

    if len(unique_checkstyle_targets) != len(checkstyle_targets):
        non_unique_checkstyle_target = set([x for x in checkstyle_targets if checkstyle_targets.count(x) > 1])
        non_unique_checkstyle_target_count = len(non_unique_checkstyle_target)
        print('ERROR: Found %d bazel targets which are covered more than once:' % non_unique_checkstyle_target_count)
        for i, target_label in enumerate(non_unique_checkstyle_target, start=1):
            print('%d: %s' % (i, target_label))
        sys.exit(1)

    java_targets_with_no_checkstyle = set(java_targets) - set(checkstyle_targets)
    target_count = len(java_targets_with_no_checkstyle)

    if java_targets_with_no_checkstyle:
        print('ERROR: Found %d bazel targets which are not covered by a `checkstyle_test`:' % target_count)
        for i, target_label in enumerate(java_targets_with_no_checkstyle, start=1):
            print('%d: %s' % (i, target_label))
        sys.exit(1)
    else:
        print('SUCCESS: Every source code is covered by a `checkstyle_test`!')
