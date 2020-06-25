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

def _release_validate_deps_test_impl(ctx):
    test_script = ctx.actions.declare_file("{}.py".format(ctx.attr.name))

    ctx.actions.expand_template(
        output = test_script,
        template = ctx.file._release_validate_deps_template,
        is_executable = True,
        substitutions = {
            "{workspace_refs_json_path}": ctx.file.refs.path,
            "{tagged_deps}": ",".join(ctx.attr.tagged_deps),
        }
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
        "_release_validate_deps_template": attr.label(
            allow_single_file=True,
            default = "@graknlabs_dependencies//ci/templates:release_validate_deps.py"
        )
    },
    implementation = _release_validate_deps_test_impl,
    test = True
)
