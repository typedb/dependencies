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

    # Get all BUILD and *.bzl files that are declared in the current repository
    build_files, _ = tc.shell_execute([
        'bazel', 'query', 'filter("^//.*", buildfiles(//...))'
    ], cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY"))
    build_files = build_files.split()

    checkstyle_targets_xml, _ = tc.shell_execute([
        'bazel', 'query', 'kind(checkstyle_test, //...)', '--output', 'xml'
    ], cwd=os.getenv("BUILD_WORKSPACE_DIRECTORY"))
    checkstyle_targets_tree = ElementTree.fromstring(checkstyle_targets_xml)
    java_targets_covered_by_target_attr = checkstyle_targets_tree.findall(".//label[@name='target'][@value]")
    java_targets_covered_by_targets_attr = checkstyle_targets_tree.findall(".//list[@name='targets']//label[@value]")
    checkstyle_targets = list(map(
        lambda x: x.get('value'), java_targets_covered_by_target_attr + java_targets_covered_by_targets_attr))
    unique_checkstyle_targets = set(checkstyle_targets)
    files = checkstyle_targets_tree.findall(".//list[@name='files']//label[@value]")
    checkstyle_files = list(map(lambda x: x.get('value'), files))
    unique_checkstyle_files = set(checkstyle_files)

    if len(unique_checkstyle_targets) != len(checkstyle_targets):
        non_unique_checkstyle_target = set([x for x in checkstyle_targets if checkstyle_targets.count(x) > 1])
        non_unique_checkstyle_target_count = len(non_unique_checkstyle_target)
        print('ERROR: Found %d bazel targets which are covered more than once:' % non_unique_checkstyle_target_count)
        for i, target_label in enumerate(non_unique_checkstyle_target, start=1):
            print('%d: %s' % (i, target_label))
        sys.exit(1)

    if len(unique_checkstyle_files) != len(checkstyle_files):
        non_unique_checkstyle_file = set([x for x in checkstyle_files if checkstyle_files.count(x) > 1])
        non_unique_checkstyle_file_count = len(non_unique_checkstyle_file)
        print('ERROR: Found %d build files which are covered more than once:' % non_unique_checkstyle_file_count)
        for i, target_label in enumerate(non_unique_checkstyle_file, start=1):
            print('%d: %s' % (i, target_label))
        sys.exit(1)

    java_targets_with_no_checkstyle = set(java_targets) - set(checkstyle_targets)
    target_count = len(java_targets_with_no_checkstyle)

    if java_targets_with_no_checkstyle:
        print('ERROR: Found %d bazel targets which are not covered by a `checkstyle_test`:' % target_count)
        for i, target_label in enumerate(java_targets_with_no_checkstyle, start=1):
            print('%d: %s' % (i, target_label))
        sys.exit(1)

    build_files_with_no_checkstyle = set(build_files) - set(checkstyle_files)
    file_count = len(build_files_with_no_checkstyle)

    if build_files_with_no_checkstyle:
        print('ERROR: Found %d build files which are not covered by a `checkstyle_test`:' % file_count)
        for i, file_label in enumerate(build_files_with_no_checkstyle, start=1):
            print('%d: %s' % (i, file_label))
        sys.exit(1)

    print('SUCCESS: Every Java source and build file is covered by a `checkstyle_test`!')
