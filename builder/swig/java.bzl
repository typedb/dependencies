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

def _swig_java_wrapper_impl(ctx):
    module_name = getattr(ctx.attr, "class_name", ctx.attr.name)
    if ctx.file.interface:
        interface = ctx.file.interface
    else:
        interface = _create_interface(ctx, module_name)

    wrap_c = ctx.actions.declare_file("{}_wrap.c".format(module_name))
    wrap_java_dir = ctx.actions.declare_directory("{}".format(module_name))

    ctx.actions.run(
        inputs = depset([interface], transitive = [
            ctx.attr.lib[CcInfo].compilation_context.headers,
            ctx.attr._swig.data_runfiles.files,
        ]),
        outputs = [wrap_c, wrap_java_dir],
        executable = ctx.file._swig,
        arguments = [
            "-java",
            "-package", ctx.attr.package,
            "-outdir", wrap_java_dir.path,
            interface.path,
        ],
    )

    wrap_zip = ctx.actions.declare_file(module_name + ".zip")

    args = ctx.actions.args()
    args.add("c")
    args.add(wrap_zip.path)
    args.add_all([wrap_java_dir])

    ctx.actions.run(
        inputs = [wrap_java_dir],
        outputs = [wrap_zip],
        executable = ctx.executable._zipper,
        arguments = [args],
    )

    wrap_srcjar = ctx.actions.declare_file(module_name + ".srcjar")
    ctx.actions.run_shell(
        inputs = [wrap_zip],
        outputs = [wrap_srcjar],
        command = "mv {} {}".format(wrap_zip.path, wrap_srcjar.path),
    )

    jni_h = ctx.actions.declare_file("jni.h")
    ctx.actions.run_shell(
        inputs = [ctx.file._jni_header],
        outputs = [jni_h],
        command = "cp -f '%s' '%s'" % (ctx.file._jni_header.path, jni_h.path),
    )

    jni_md_h = ctx.actions.declare_file("jni_md.h")
    ctx.actions.run_shell(
        inputs = [ctx.file.jni_md_header],
        outputs = [jni_md_h],
        command = "cp -f '%s' '%s'" % (ctx.file.jni_md_header.path, jni_md_h.path),
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
        DefaultInfo(files = depset([interface, jni_h, jni_md_h, wrap_c, wrap_srcjar])),
        CcInfo(
            compilation_context = compilation_context,
            linking_context = ctx.attr.lib[CcInfo].linking_context,
        ),
    ]


_swig_java_wrapper = rule(
    implementation = _swig_java_wrapper_impl,
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
        "_jni_header": attr.label(
            default = Label("@bazel_tools//tools/jdk:jni_header"),
            allow_single_file = True,
        ),
        "jni_md_header": attr.label(
            allow_single_file = True,
        ),
        "_swig": attr.label(
            default = Label("@swig//:swig"),
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
        "_zipper": attr.label(
            default = Label("@bazel_tools//tools/zip:zipper"),
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
    },
)


def swig_java_wrapper(**kwargs):
    # workaround for select() not being allowed as a default argument
    # cf. https://github.com/bazelbuild/bazel/issues/287
    _swig_java_wrapper(
        jni_md_header = select({
            "@vaticle_dependencies//util/platform:is_mac": Label("@bazel_tools//tools/jdk:jni_md_header-darwin"),
            "@vaticle_dependencies//util/platform:is_linux": Label("@bazel_tools//tools/jdk:jni_md_header-linux"),
            "@vaticle_dependencies//util/platform:is_windows": Label("@bazel_tools//tools/jdk:jni_md_header-windows"),
        }),
        **kwargs,
    )


def swig_java(name, lib, shared_lib_name=None, **kwargs):
    swig_wrapper_name = name + "__swig"
    swig_java_wrapper(
        name = swig_wrapper_name,
        class_name = name,
        lib = lib,
        **kwargs,
    )

    if not shared_lib_name:
        shared_lib_name = "lib" + name

    def swig_cc_binary(shared_lib_filename):
        # name doesn't accept select() either
        native.cc_binary(
            name = shared_lib_filename,
            deps = [lib, swig_wrapper_name],
            srcs = [swig_wrapper_name],
            linkshared = True,
        )

    select({
        "@vaticle_dependencies//util/platform:is_mac": swig_cc_binary(shared_lib_name + ".dylib"),
        "@vaticle_dependencies//util/platform:is_linux": swig_cc_binary(shared_lib_name + ".so"),
        "@vaticle_dependencies//util/platform:is_windows": swig_cc_binary(shared_lib_name + ".lib"),
    })

    native.alias(
        name = shared_lib_name,
        actual = select({
            "@vaticle_dependencies//util/platform:is_mac": (shared_lib_name + ".dylib"),
            "@vaticle_dependencies//util/platform:is_linux": (shared_lib_name + ".so"),
            "@vaticle_dependencies//util/platform:is_windows": (shared_lib_name + ".lib"),
        })
    )

    native.java_library(name = name, srcs = [swig_wrapper_name])


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
