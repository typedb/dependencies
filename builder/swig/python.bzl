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

def _copy_to_bin(ctx, src, dst):
    ctx.actions.run_shell(
        inputs = [src],
        outputs = [dst],
        command = "cp -f '{}' '{}'".format(src.path, dst.path),
    )

def _swig_python_wrapper_impl(ctx):
    module_name = getattr(ctx.attr, "class_name", ctx.attr.name)
    interface_name = getattr(ctx.attr, "shared_lib_name", "_" + ctx.attr.name)

    args = ctx.attr.extra_args + [
        "-python",
        "-module", module_name,
        "-interface", interface_name,
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

    wrap_py = ctx.actions.declare_file("{}.py".format(module_name))

    for h in ctx.attr.lib[CcInfo].compilation_context.headers.to_list():
        args = ["-I" + h.dirname] + args

    ctx.actions.run(
        inputs = depset([ctx.file.interface] + ctx.files.includes, transitive = [
                    ctx.attr.lib[CcInfo].compilation_context.headers,
                    ctx.attr._swig.data_runfiles.files,
                ]),
        outputs = [wrap_src, wrap_py] + swig_headers,
        executable = ctx.file._swig,
        arguments = args,
    )

    lib_compilation_context = ctx.attr.lib[CcInfo].compilation_context
    compilation_context = cc_common.create_compilation_context(
        headers = depset(ctx.attr._python_header[CcInfo].compilation_context.headers.to_list() + swig_headers, transitive = [lib_compilation_context.headers]),
        defines = lib_compilation_context.defines,
        framework_includes = lib_compilation_context.framework_includes,
        includes = lib_compilation_context.includes,
        local_defines = lib_compilation_context.local_defines,
        quote_includes = lib_compilation_context.quote_includes,
        system_includes = depset(
            [file.dirname for file in ctx.attr._python_header[CcInfo].compilation_context.headers.to_list()],
            transitive = [lib_compilation_context.system_includes],
        )
    )

    linking_context = cc_common.create_linking_context(
        linker_inputs = depset([], transitive = [ctx.attr._libpython[CcInfo].linking_context.linker_inputs, ctx.attr.lib[CcInfo].linking_context.linker_inputs]),
    )

    return [
        DefaultInfo(files = depset([wrap_src, wrap_py])),
        CcInfo(
            compilation_context = compilation_context,
            linking_context = linking_context,
        ),
    ]


swig_python_wrapper = rule(
    implementation = _swig_python_wrapper_impl,
    attrs = {
        "lib": attr.label(
            doc = "The C library for which to generate the wrapper",
            providers = [CcInfo],
            mandatory = True,
        ),
        "class_name": attr.string(
            doc = "Optional override for the python class name (default: same as target name)",
        ),
        "shared_lib_name": attr.string(
            doc = "Optional override for the dynamic library name (default: '_' + target name)",
        ),
        "interface": attr.label(
            doc = "Optional SWIG interface (.i) file",
            allow_single_file = True,
        ),
        "includes": attr.label_list(
            doc = "Additional SWIG files required for wrapper generation",
            allow_files = True,
        ),
        "enable_cxx": attr.bool(
            doc = "Enable SWIG C++ processing (default: False)",
            default = True,
        ),
        "extra_args": attr.string_list(
            doc = "Extra arguments to be passed to SWIG",
        ),
        "_python_header": attr.label(
            default = Label("@python39//:python_headers"),
        ),
        "_libpython": attr.label(
            default = Label("@python39//:libpython"),
        ),
        "_swig": attr.label(
            default = Label("@swig//:swig"),
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
    },
)


def swig_python(name, lib, shared_lib_name=None, **kwargs):
    swig_wrapper_name = name + "__swig"
    if not shared_lib_name:
        shared_lib_name = "_" + name

    swig_python_wrapper(
        class_name = name,
        name = swig_wrapper_name,
        shared_lib_name = shared_lib_name,
        lib = lib,
        **kwargs,
    )

    def swig_cc_binary(shared_lib_filename):
        # name doesn't accept select()
        native.cc_binary(
            name = shared_lib_filename,
            deps = [lib, swig_wrapper_name],
            srcs = [swig_wrapper_name],
            linkshared = True,
            copts = ["/DCOMPILING_DLL"],
            linkopts = ["/LIBPATH:C:\\Windows\\System32"]
        )

    swig_cc_binary(shared_lib_name + ".so")
    swig_cc_binary(shared_lib_name + ".lib")

    native.alias(
        name = shared_lib_name,
        actual = select({
            "@vaticle_dependencies//util/platform:is_mac": (shared_lib_name + ".so"),
            "@vaticle_dependencies//util/platform:is_linux": (shared_lib_name + ".so"),
            "@vaticle_dependencies//util/platform:is_windows": (shared_lib_name + ".lib"),
        })
    )

    native.py_library(name = name, srcs = [swig_wrapper_name], data = [shared_lib_name])
