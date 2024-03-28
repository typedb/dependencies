# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


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
