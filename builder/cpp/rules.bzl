#
# Copyright (C) 2022 Vaticle
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

def _clang_format_test_impl(ctx):
    files = []
    for target in ctx.attr.include:
        path = target.files.to_list()[0].path;
        if target not in ctx.attr.exclude:
            files.extend(target.files.to_list())

    cmd = " ".join(
        [ctx.file._clang_format_sh.path, ctx.file._clang_format_style.path] +
        [file.path for file in files]
    )

    wrapper_script = ctx.actions.declare_file("clang_format_wrapper__%s.sh" % ctx.attr.name)
    ctx.actions.write(
        output = wrapper_script,
        content = cmd,
        is_executable = True,
    )

    files = [wrapper_script]  + [ctx.file._clang_format_sh, ctx.file._clang_format_style] + files
    runfiles = ctx.runfiles(
        files = files,
        collect_data = True,
    )
    return DefaultInfo(
        executable = wrapper_script,
        files = depset(files),
        runfiles = runfiles,
    )

clang_format_test = rule(
    implementation = _clang_format_test_impl,
    test = True,
    attrs = {
        "include": attr.label_list(
            doc = "A list of files that should be checked",
            allow_files = True,
        ),
        "exclude": attr.label_list(
            doc = "A list of files that should be excluded from checking",
            allow_files = True,
            default = [],
        ),
        "_clang_format_sh": attr.label(
             allow_single_file=True,
             default = "//library/cpp:clang_format.sh"
        ),
        "_clang_format_style": attr.label(
             allow_single_file=True,
             default = "//library/cpp:.clang-format"
        ),
    },
)
