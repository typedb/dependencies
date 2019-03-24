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

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

# TODO: revert to graknlabs/bazel-distribution and remove local_repository before merging the PR to master
def graknlabs_bazel_distribution():
#    native.local_repository(
#        name = "graknlabs_bazel_distribution",
#        path = "/Users/lolski/grakn.ai/bazel-distribution"
#    )
    git_repository(
        name = "graknlabs_bazel_distribution",
        remote = "https://github.com/lolski/bazel-distribution",
        commit = "83efaaa2d2a539bc2c101c6704b619a77ccc6e30" # sync-marker: do not remove this comment, this is used for sync-dependencies by @graknlabs_bazel_distribution
    )
