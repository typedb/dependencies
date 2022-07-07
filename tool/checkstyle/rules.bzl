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

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_test")

def _checkstyle_wrapper_impl(ctx):
    properties = ctx.file.properties
    opts = ctx.attr.opts
    sopts = ctx.attr.string_opts

    args = ""
    inputs = []

    license_file = "external/vaticle_dependencies/tool/checkstyle/config/checkstyle-file-%s.txt" % ctx.attr.license_type

    config = ctx.actions.declare_file("%s.xml" % ctx.attr.name)
    ctx.actions.expand_template(
        template = ctx.file._checkstyle_xml_template,
        output = config,
        substitutions = {
            "{licenseFile}" : license_file
        }
    )

    args += " -c "
    if ctx.label.package:
        args += ctx.label.package + '/'
    args += config.basename

    inputs.append(config)

    if properties:
      args += " -p %s" % properties.path
      inputs.append(properties)

    files = []
    for target in ctx.attr.include:
        path = target.files.to_list()[0].path;
        if target not in ctx.attr.exclude:
            files.extend(target.files.to_list())

    classpath = ":".join([file.path for file in ctx.files._classpath])
    cmd = " ".join(
        ["java -cp %s com.puppycrawl.tools.checkstyle.Main" % classpath] +
        [args] +
        ["--%s" % x for x in opts] +
        ["--%s %s" % (k, sopts[k]) for k in sopts] +
        [file.path for file in files]
    )

    checkstyle_wrapper = ctx.actions.declare_file("%s.kt" % ctx.attr.name)
    ctx.actions.expand_template(
        template = ctx.file._checkstyle_kt_template,
        output = checkstyle_wrapper,
        substitutions = {
            "{command}" : cmd,
        },
        is_executable = True,
    )

    files = [checkstyle_wrapper] + ctx.files._license_files + files + ctx.files._classpath + inputs
    runfiles = ctx.runfiles(
        files = files,
        collect_data = True,
    )
    return DefaultInfo(
        executable = checkstyle_wrapper,
        runfiles = runfiles,
    )

_checkstyle_wrapper = rule(
    implementation = _checkstyle_wrapper_impl,
    attrs = {
        "license_type": attr.string(
            doc = "Type of license to produce the header for every source code",
            values = [
                "agpl-header",
                "apache-header",
                "commercial-header",
                "agpl-fulltext",
                "apache-fulltext",
                "commercial-fulltext",
            ],
            mandatory = True,
        ),
        "properties": attr.label(
            allow_single_file=True,
            doc = "A properties file to be used"
        ),
        "opts": attr.string_list(
            doc = "Options to be passed on the command line that have no argument"
        ),
        "string_opts": attr.string_dict(
            doc = "Options to be passed on the command line that have an argument"
        ),
        "include": attr.label_list(
            doc = "A list of files that should be checked",
            allow_files = True,
        ),
        "exclude": attr.label_list(
            doc = "A list of files that should be excluded from checking (in addition to the default exclusions)",
            allow_files = True,
            default = [],
        ),
        "_checkstyle_kt_template": attr.label(
             allow_single_file=True,
             default = "//tool/checkstyle/templates:Checkstyle.kt"
        ),
        "_checkstyle_xml_template": attr.label(
             allow_single_file=True,
             default = "//tool/checkstyle/templates:checkstyle.xml"
        ),
        "_classpath": attr.label_list(default=[
            Label("@com_puppycrawl_tools_checkstyle//jar"),
            Label("@commons_beanutils_commons_beanutils//jar"),
            Label("@info_picocli_picocli//jar"),
            Label("@commons_collections_commons_collections//jar"),
            Label("@org_slf4j_slf4j_api//jar"),
            Label("@org_slf4j_slf4j_jcl//jar"),
            Label("@antlr_antlr//jar"),
            Label("@org_antlr_antlr4_runtime//jar"),
            Label("@com_google_guava_guava30jre//jar"),
        ]),
        "_license_files": attr.label_list(
            allow_files=True,
            doc = "License file(s) that can be used with the checkstyle license target",
            default = ["@vaticle_dependencies//tool/checkstyle/config:license_files"]
        ),
    },
)

def checkstyle_test(name, size = "small", **kwargs):
    wrapper_target_name = name.capitalize().replace("-","_") + "_"

    _checkstyle_wrapper(name = wrapper_target_name, **kwargs)

    kt_jvm_test(
        name = name,
        main_class = "com.vaticle.dependencies.tool.checkstyle.templates." + wrapper_target_name + "Kt",
        srcs = [wrapper_target_name],
        deps = ["@vaticle_dependencies//util:common", "@maven//:org_zeroturnaround_zt_exec"],
        size = size,
    )
