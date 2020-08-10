#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2020 Grakn Labs Ltd
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

RELEASE_VALIDATE_DEPS_SCRIPT_TEMPLATE = """
import json
import sys

with open("{workspace_refs_json_path}") as f:
    workspace_refs = json.load(f)

tagged_deps = set("{tagged_deps}".split(','))
snapshot_dependencies = tagged_deps - set(workspace_refs['tags'])

if snapshot_dependencies:
    print('These dependencies are excepted to be declared by tag instead of commit: {}'.format(snapshot_dependencies))
    sys.exit(1)
"""

def _release_validate_deps_test_impl(ctx):
    test_script = ctx.actions.declare_file("{}.py".format(ctx.attr.name))

    ctx.actions.write(
        output = test_script,
        content = RELEASE_VALIDATE_DEPS_SCRIPT_TEMPLATE.format(
            workspace_refs_json_path=ctx.file.refs.path,
            tagged_deps=ctx.attr.tagged_deps
        ),
        is_executable = True,
    )

    return [
        DefaultInfo(
            executable = test_script,
            runfiles = ctx.runfiles(files = [test_script, ctx.file.refs])
        )
    ]


release_validate_deps_test = rule(
    attrs = {
        "refs": attr.label(
            allow_single_file = True,
            mandatory = True
        ),
        "tagged_deps": attr.string_list(
            mandatory = True
        ),
    },
    implementation = _release_validate_deps_test_impl,
    test = True
)
