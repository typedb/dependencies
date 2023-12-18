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

def _doxygen_docs_impl(ctx):
    output_directory = ctx.actions.declare_directory(ctx.attr._output_directory)
    files = []
    for target in ctx.attr.sources:
        files.extend(target.files.to_list())

    replacements = {
        "PROJECT_NAME": ctx.attr.project_name,
        "OUTPUT_DIRECTORY" : output_directory.path
    }
    if ctx.attr.strip_from_path != None:
            replacements["STRIP_FROM_PATH"] =ctx.attr.strip_from_path

    if ctx.file.main_page_md != None:
        files.append(ctx.file.main_page_md)
        replacements["USE_MDFILE_AS_MAINPAGE"] = ctx.file.main_page_md.path

    replacements["INPUT"] = " ".join([f.path for f in files])

    # Prepare doxyfile replacements
    replacements_file = ctx.actions.declare_file("%s.replacements" % ctx.attr.name)
    ctx.actions.write(
        output = replacements_file,
        content = "\n".join([(k + " = " +replacements[k]) for k in replacements]),
        is_executable = False,
    )

    # Prepare doxyfile
    doxyfile = ctx.actions.declare_file("%s.doxyfile" % ctx.attr.name)
    ctx.actions.run(
        inputs = [ctx.file._templater_script, ctx.file._doxyfile_template, replacements_file],
        outputs = [doxyfile],
        arguments = [ctx.file._templater_script.path, ctx.file._doxyfile_template.path, replacements_file.path, doxyfile.path],
        executable = "python3",
        use_default_shell_env = True
    )
    files = [doxyfile] + files
    print(doxyfile.path)
    ctx.actions.run(
        inputs = files,
        outputs = [output_directory],
        arguments = [doxyfile.path],
        executable = "doxygen",
        use_default_shell_env = True
    )

    return DefaultInfo(files = depset([output_directory]))

doxygen_docs = rule(
    implementation = _doxygen_docs_impl,
    test = False,
    attrs = {
        "project_name" : attr.string(
            doc = "The project name for the doxygen docs",
            mandatory = True,
        ),
        "sources" : attr.label_list(
            doc = "A list of files made available to doxygen. This is NOT automatically included in the doxyfile",
            mandatory = True,
            allow_files = True,
        ),
        "strip_from_path" : attr.string(
            doc = "Prefix to strip from path of files being processed",
            mandatory = False
        ),
        "main_page_md" : attr.label(
            doc = "The file to use as main page for the generate docs",
            allow_single_file = True,
            mandatory = False
        ),
        "_doxyfile_template" : attr.label(
             doc = "A template for the doxygen configuration file.",
             allow_single_file = True,
             default = "//library/cpp:doxyfile.template"
         ),
         "_output_directory" : attr.string(
             doc = "The output directory for the doxygen docs",
             default = "doxygen_docs"
         ),
         "_templater_script": attr.label(
             default = "//library/cpp:doxyfile_templater.py",
             allow_single_file = True,
         )
    },
)
