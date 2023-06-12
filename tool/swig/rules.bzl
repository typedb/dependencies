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

def _swig_java_impl(ctx):
    module_name = getattr(ctx.attr, "class_name", ctx.attr.name)
    if ctx.file.interface:
        interface = ctx.file.interface
    else:
        interface = _create_interface(ctx, module_name)

    wrap_c = ctx.actions.declare_file("{}_wrap.c".format(module_name))
    wrap_java = ctx.actions.declare_file("{}.java".format(module_name))
    wrap_java_jni = ctx.actions.declare_file("{}JNI.java".format(module_name))

    ctx.actions.run(
        inputs = depset([interface], transitive = [
            ctx.attr.lib[CcInfo].compilation_context.headers,
            ctx.attr._swig.data_runfiles.files,
        ]),
        outputs = [wrap_c, wrap_java, wrap_java_jni],
        executable = ctx.file._swig,
        arguments = [
            "-java",
            "-package", ctx.attr.package,
            interface.path,
        ],
    )

    jni_h = ctx.actions.declare_file("jni.h")
    ctx.actions.run_shell(
        inputs = [ctx.file._jni_header],
        outputs = [jni_h],
        command = "cp -f '%s' '%s'" % (ctx.file._jni_header.path, jni_h.path),
    )

    jni_md_h = ctx.actions.declare_file("jni_md.h")
    ctx.actions.run_shell(
        inputs = [ctx.file._jni_md_header],
        outputs = [jni_md_h],
        command = "cp -f '%s' '%s'" % (ctx.file._jni_md_header.path, jni_md_h.path),
    )

    lib_compilation_context = ctx.attr.lib[CcInfo].compilation_context
    compilation_context = cc_common.create_compilation_context(
        headers = lib_compilation_context.headers,
        defines = lib_compilation_context.defines,
        framework_includes = lib_compilation_context.framework_includes,
        includes = lib_compilation_context.includes,
        local_defines = lib_compilation_context.local_defines,
        quote_includes = lib_compilation_context.quote_includes,
        system_includes = depset(
            [jni_h.dirname, jni_md_h.dirname],
            transitive = [lib_compilation_context.system_includes],
        )
    )

    return [
        DefaultInfo(files = depset([interface, jni_h, jni_md_h, wrap_c, wrap_java, wrap_java_jni])),
        CcInfo(
            compilation_context = compilation_context,
            linking_context = ctx.attr.lib[CcInfo].linking_context,
        ),
    ]

swig_java = rule(
    implementation = _swig_java_impl,
    attrs = {
        "lib": attr.label(
            doc = "The C library for which to generate the wrapper",
            providers = [CcInfo],
            mandatory = True,
        ),
        "class_name": attr.string(
            doc = "optional override for the java class name (default: same as target name)",
        ),
        "interface": attr.label(
            doc = "Optional override for the generated SWIG interface (.i) file.",
            allow_single_file = True,
        ),
        "package": attr.string(
            mandatory = True,
        ),
        "_swig": attr.label(
            default = Label("@swig//:swig"),
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
        "_jni_header": attr.label(
            default = Label("@bazel_tools//tools/jdk:jni_header"),
            allow_single_file = True,
        ),
        "_jni_md_header": attr.label(
            default = Label("@bazel_tools//tools/jdk:jni_md_header-darwin"),
            allow_single_file = True,
        ),
    }
)


def _create_interface(ctx, module_name):
    interface = ctx.actions.declare_file(module_name + ".i")
    includes = "\n".join([
        "#include \"{}\"".format(hdr.path)
        for hdr in ctx.attr.lib[CcInfo].compilation_context.headers.to_list()
    ])
    swig_includes = includes.replace("#", "%")
    ctx.actions.write(
        interface,
        # TODO template
        "%module {}\n%{{\n{}\n%}}\n%include \"stdint.i\"\n{}".format(module_name, includes, swig_includes)
    )
    return interface
