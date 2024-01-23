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

# TODO: Generalise and move the same functions (used by java, python, csharp)
# to a base file, add reusage where possible.

load("@rules_dotnet//dotnet:defs.bzl", "csharp_binary", "csharp_library")

def _copy_to_bin(ctx, src, dst):
    ctx.actions.run_shell(
        inputs = [src],
        outputs = [dst],
        command = "cp -f '{}' '{}'".format(src.path, dst.path),
    )

def _swig_csharp_wrapper_impl(ctx):
    module_name = getattr(ctx.attr, "class_name", ctx.attr.name)

    wrap_csharp = ctx.actions.declare_file("{}.cs".format(module_name))

    args = ctx.attr.extra_args + [
        "-csharp",
        "-namespace", ctx.attr.namespace,
        "-outfile", wrap_csharp.path,
        ctx.file.interface.path,
    ]

    if ctx.attr.enable_cxx:
        wrap_src = ctx.actions.declare_file("{}_wrap.cxx".format(module_name))
        directors_header = ctx.actions.declare_file("{}_wrap.h".format(module_name))
        args = ["-c++", "-o", wrap_src.path, "-oh", directors_header.path] + args
        swig_headers = [directors_header]
    else:
        wrap_src = ctx.actions.declare_file("{}_wrap.c".format(module_name))
        args = ["-o", wrap_src.path] + args
        swig_headers = []
    
    for h in ctx.attr.lib[CcInfo].compilation_context.headers.to_list():
        args = ["-I" + h.dirname] + args

    ctx.actions.run(
        inputs = depset(
            [ctx.file.interface] + ctx.files.includes,
            transitive = [
                ctx.attr.lib[CcInfo].compilation_context.headers,
                ctx.attr._swig.data_runfiles.files,
        ]),
        outputs = [wrap_src, wrap_csharp] + swig_headers,
        executable = ctx.file._swig,
        arguments = args,
    )

    # TODO: What to do for csharp?
    jni_h = ctx.actions.declare_file("jni.h")
    _copy_to_bin(ctx, ctx.file._jni_header, jni_h)

    jni_md_h = ctx.actions.declare_file("jni_md.h")
    _copy_to_bin(ctx, ctx.file.jni_md_header, jni_md_h)

    lib_compilation_context = ctx.attr.lib[CcInfo].compilation_context
    compilation_context = cc_common.create_compilation_context(
        # TODO: Probably fix the headers here
        headers = depset(swig_headers, transitive = [lib_compilation_context.headers]),
        defines = lib_compilation_context.defines,
        framework_includes = lib_compilation_context.framework_includes,
        includes = depset(
            [h.dirname for h in ctx.attr.lib[CcInfo].compilation_context.headers.to_list()],
            transitive = [lib_compilation_context.includes],
        ),
        local_defines = lib_compilation_context.local_defines,
        quote_includes = lib_compilation_context.quote_includes,
        system_includes = depset(
            [jni_h.dirname, jni_md_h.dirname],
            transitive = [lib_compilation_context.system_includes],
        )
    )

    return [
        # TODO: jni_h, jni_md_h
        DefaultInfo(files = depset([jni_h, jni_md_h, wrap_src, wrap_csharp])),
        CcInfo(
            compilation_context = compilation_context,
            linking_context = ctx.attr.lib[CcInfo].linking_context,
        ),
    ]


_swig_csharp_wrapper = rule(
    implementation = _swig_csharp_wrapper_impl,
    attrs = {
        "lib": attr.label(
            doc = "The C library for which to generate the wrapper",
            providers = [CcInfo],
            mandatory = True,
        ),
        "class_name": attr.string(
            doc = "Optional override for the C# class name (default: same as target name)",
        ),
        "interface": attr.label(
            doc = "Optional SWIG interface (.i) file",
            allow_single_file = True,
        ),
        "includes": attr.label_list(
            doc = "Additional SWIG files required for wrapper generation",
            allow_files = True,
        ),
        "namespace": attr.string(
            doc = "C# namespace where to put the sources",
            mandatory = True,
        ),
        "enable_cxx": attr.bool(
            doc = "Enable SWIG C++ processing (default: False)",
            default = False,
        ),
        "extra_args": attr.string_list(
            doc = "Extra arguments to be passed to SWIG",
        ),
        "_jni_header": attr.label( # TODO: Change to Csharp??
            default = Label("@bazel_tools//tools/jdk:jni_header"),
            allow_single_file = True,
        ),
        "jni_md_header": attr.label( # TODO: Change to PInvoke??
            allow_single_file = True,
        ),
        "_swig": attr.label(
            default = Label("@swig//:swig"),
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
    },
)

# TODO: jni_md_header to csharp
def swig_csharp_wrapper(**kwargs):
    # workaround for select() not being allowed as a default argument
    # cf. https://github.com/bazelbuild/bazel/issues/287
    _swig_csharp_wrapper(
        jni_md_header = select({
            "@vaticle_bazel_distribution//platform:is_mac": Label("@bazel_tools//tools/jdk:jni_md_header-darwin"),
            "@vaticle_bazel_distribution//platform:is_linux": Label("@bazel_tools//tools/jdk:jni_md_header-linux"),
            "@vaticle_bazel_distribution//platform:is_windows": Label("@bazel_tools//tools/jdk:jni_md_header-windows"),
        }),
        **kwargs,
    )


def swig_csharp(name, lib, shared_lib_name=None, tags=[], **kwargs):
    swig_wrapper_name = name + "__swig"
    swig_csharp_wrapper(
        name = swig_wrapper_name,
        class_name = name,
        lib = lib,
        **kwargs,
    )

    if not shared_lib_name:
        shared_lib_name = name

    def swig_cc_binary(shared_lib_filename):
        # name doesn't accept select() either
        native.cc_binary(
            name = shared_lib_filename,
            deps = [lib, swig_wrapper_name],
            srcs = [swig_wrapper_name],
            linkshared = True,
            linkopts = select({
                # TODO: move http certificate/encryption libraries into arguments
                "@vaticle_bazel_distribution//platform:is_windows": ["ntdll.lib", "secur32.lib", "crypt32.lib", "ncrypt.lib"],
                "//conditions:default": [],
            }),
        )

    # TODO: Maybe don't create multiple files for specific platform.
    swig_cc_binary("lib" + shared_lib_name + ".dylib")
    swig_cc_binary("lib" + shared_lib_name + ".so")
    swig_cc_binary(shared_lib_name + ".dll")

    native.alias(
        name = "lib" + shared_lib_name,
        actual = select({
            "@vaticle_bazel_distribution//platform:is_mac": ("lib" + shared_lib_name + ".dylib"),
            "@vaticle_bazel_distribution//platform:is_linux": ("lib" + shared_lib_name + ".so"),
            "@vaticle_bazel_distribution//platform:is_windows": (shared_lib_name + ".dll"),
        })
    )

    csharp_library(
        name = name,
        srcs = [swig_wrapper_name],
        resources = ["lib" + shared_lib_name],
        tags = tags,
    )
