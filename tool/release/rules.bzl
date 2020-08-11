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

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")

def _release_validate_deps_script_impl(ctx):
    test_script = ctx.actions.declare_file("{}.kt".format(ctx.attr.name))

    ctx.actions.expand_template(
        output = test_script,
        template = ctx.file._release_validate_deps_template,
        substitutions = {
            "{workspace_refs_json_path}": ctx.file.refs.path,
            "{tagged_deps}": ",".join(ctx.attr.tagged_deps),
        }
    )

    return [
        DefaultInfo(
            runfiles = ctx.runfiles(files = [ctx.file.refs]),
            files = depset(direct = [test_script])
        )
    ]


release_validate_deps_script = rule(
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
            default = "@graknlabs_dependencies//tool/release:ValidateDeps.kt"
        )
    },
    implementation = _release_validate_deps_script_impl,

)

def release_validate_deps(name, **kwargs):
    standard_name = name.capitalize().replace("-","_")
    target_name = standard_name + "_gen"

    release_validate_deps_script(
        name = target_name,
        **kwargs
    )

    kt_jvm_binary(
        name = name,
        main_class = "tool.release." + standard_name + "_genKt",
        srcs = [target_name],
        deps = [
            "@maven//:com_eclipsesource_minimal_json_minimal_json"
        ]
    )
