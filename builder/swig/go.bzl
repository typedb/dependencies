# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.
load("@io_bazel_rules_go//go:def.bzl", "go_library")


def _copy_to_bin(ctx, src, dst):
    ctx.actions.run_shell(
        inputs = [src],
        outputs = [dst],
        command = "cp -f '{}' '{}'".format(src.path, dst.path),
    )

def _swig_go_wrapper_impl(ctx):
    module_name = ctx.attr.name

    wrap_go_dir = ctx.actions.declare_directory("{}".format(module_name))

    args = ctx.attr.extra_args + [
        "-go",
#        "c++",
        "-outdir", wrap_go_dir.path,
        "-package", "typedb_driver", # name of the import in the driver
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

#    out_file = ctx.actions.declare_file("target.go")

    ctx.actions.run(
        inputs = depset(
            [ctx.file.interface] + ctx.files.includes,

            transitive = [
                ctx.attr.lib[CcInfo].compilation_context.headers,
                ctx.attr._swig.data_runfiles.files,
            ]),
        outputs = [wrap_src, wrap_go_dir] + swig_headers,
        executable = ctx.file._swig,
        arguments = args,
    )
    # get the directory. call the target by a name.


    # we get the file from the go_dir and we use the cmd to generate a .go file that is inside this dir. it is stored in
    # the outs. We can get this by calling the target by its name.
#    out_file = ctx.actions.declare_file("foo.go")
#
##    cmd = """
##        set -e
##        GENERATED_FILE = $(cat {out_f}.go)
##        cp "$GENERATED_FILE" "{out_f}"
##        """.format(out_f=out_file.path)
#    cmd = """
#        cat {dir_p}/typedb_driver.go > {out_f}
#    """.format(out_f = out_file.path, dir_p = wrap_go_dir.path)
#
#    ctx.actions.run_shell(
#        outputs= [out_file],
#         TODO try running run shell with inputs =...
# but current verison works well too
#        command=cmd,
#        )

# if in here use ctx.actions.run_shell, genrule does not work

    lib_compilation_context = ctx.attr.lib[CcInfo].compilation_context
#    wrap_zip = ctx.actions.declare_file(module_name + ".zip")
#
#    args = ctx.actions.args()
#    args.add("c")
#    args.add(wrap_zip.path)
#    args.add_all([wrap_go_dir])
#
#    ctx.actions.run(
#        inputs = [wrap_go_dir],
#        outputs = [wrap_zip],
#        executable = ctx.executable._zipper,
#        arguments = [args],
#    )
#
#    wrap_srcjar = ctx.actions.declare_file(module_name + ".srcjar")
#    _copy_to_bin(ctx, wrap_zip, wrap_srcjar)
#
#    jni_h = ctx.actions.declare_file("jni.h")
#    _copy_to_bin(ctx, ctx.file._jni_header, jni_h)
#
#    jni_md_h = ctx.actions.declare_file("jni_md.h")
#    _copy_to_bin(ctx, ctx.file.jni_md_header, jni_md_h)
    compilation_context = cc_common.create_compilation_context(
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
            [],
            transitive = [lib_compilation_context.system_includes],
        )
    )

    return [
        DefaultInfo(files = depset([wrap_src])),
#        need to use this to seperate the go target and cxx. the .h is in the ccinfo
        OutputGroupInfo( # https://bazel.build/extending/rules#requesting_output_files
            go_source = depset([wrap_go_dir]), # its actually a dir!
            cxx_source = depset([wrap_src]),
        ),
        CcInfo(
            compilation_context = compilation_context,
            linking_context = ctx.attr.lib[CcInfo].linking_context,
        ),
    ]



_swig_go_wrapper = rule(
    implementation = _swig_go_wrapper_impl,
    attrs = {
        "lib": attr.label(
            doc = "The C library for which to generate the wrapper",
            providers = [CcInfo],
            mandatory = True,
        ),
        "class_name": attr.string(
            doc = "Optional override for the java class name (default: same as target name)",
        ),
        "interface": attr.label(
            doc = "Optional SWIG interface (.i) file",
            allow_single_file = True,
        ),
        "includes": attr.label_list(
            doc = "Additional SWIG files required for wrapper generation",
            allow_files = True,
        ),
#        "package": attr.string(
#            doc = "Java package for which to generate the sources",
#            mandatory = True,
#        ),
        "enable_cxx": attr.bool(
            doc = "Enable SWIG C++ processing (default: False)",
            default = False,
        ),
        "extra_args": attr.string_list(
            doc = "Extra arguments to be passed to SWIG",
        ),
#        "_jni_header": attr.label(
#            default = Label("@bazel_tools//tools/jdk:jni_header"),
#            allow_single_file = True,
#        ),
#        "jni_md_header": attr.label(
#            allow_single_file = True,
#        ),
        "_swig": attr.label(
            default = Label("@swig//:swig"),
            allow_single_file = True,
            executable = True,
            cfg = "host",
        ),
    },
)


def swig_go_wrapper(**kwargs):
    # workaround for select() not being allowed as a default argument
    # cf. https://github.com/bazelbuild/bazel/issues/287
    _swig_go_wrapper(
#        jni_md_header = select({
#            "@vaticle_bazel_distribution//platform:is_mac": Label("@bazel_tools//tools/jdk:jni_md_header-darwin"),
#            "@vaticle_bazel_distribution//platform:is_linux": Label("@bazel_tools//tools/jdk:jni_md_header-linux"),
#            "@vaticle_bazel_distribution//platform:is_windows": Label("@bazel_tools//tools/jdk:jni_md_header-windows"),
#        }),
        **kwargs,
    )


def swig_go(name, lib, shared_lib_name=None, tags=[], **kwargs):
    swig_wrapper_name = name + "_swig"

    swig_go_wrapper(
        name = swig_wrapper_name,
        class_name = name,
        lib = lib,
        **kwargs,
    )

    if not shared_lib_name:
        shared_lib_name = name

#    out_file = ctx.actions.declare_file("foo.go")

#    cmd = """
#        cat {swig_wrapper_name}/target.go > {out_f}
#    """.format(out_f = out_file.path)

#    ctx.actions.run_shell(
#        outputs= [out_file],
#        command=cmd,
#        )

    native.filegroup(
        name = "source_file",
        srcs = [swig_wrapper_name],
        output_group = "go_source",
    )


    native.genrule( # copy the generated go file into an output file
        name="go_wrapper_copier",
        outs= ["typedb_driver.go"],
        srcs =[":source_file"],
        cmd_bash = "cat $(SRCS)/typedb_driver.go > $@", # TODO remove hard coding
        visibility = ["//visibility:public"],
    )
    def swig_cc_binary(shared_lib_filename):
        native.cc_binary(
            name = shared_lib_filename,
            deps = [lib, swig_wrapper_name],
            srcs = [swig_wrapper_name],
            linkshared = True,
            linkopts = select({
                    "@vaticle_bazel_distribution//platform:is_windows": ["ntdll.lib", "secur32.lib", "crypt32.lib", "ncrypt.lib"],
                    "@vaticle_bazel_distribution//platform:is_mac": ["-framework CoreFoundation", "-install_name go/libtypedb_driver_go_native.dylib"],
                    "//conditions:default": [],
                }),
        )

    swig_cc_binary("lib" + shared_lib_name + ".dylib")
#    swig_cc_binary("lib" + shared_lib_name + ".so")
#    swig_cc_binary(shared_lib_name + ".dll")

    native.alias(
        name = "lib" + shared_lib_name,
        actual = select({
            "@vaticle_bazel_distribution//platform:is_mac": ("lib" + shared_lib_name + ".dylib"),
#            "@vaticle_bazel_distribution//platform:is_linux": ("lib" + shared_lib_name + ".so"),
#            "@vaticle_bazel_distribution//platform:is_windows": (shared_lib_name + ".dll"),
        })
    )

    go_library(
        name = name,
        srcs = ["typedb_driver.go"],
        data = ["lib" + shared_lib_name],
        importpath = "example/go_wrapper",
        visibility = ["//visibility:public"],
        cgo=True,

    )
    # needs name, go file (in the dir), and resource being the lib(contains cxx, .h)
    # in most cases this data file is copied to where it goes