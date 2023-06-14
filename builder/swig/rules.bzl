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

def create_swig_interface(ctx, module_name):
    interface = ctx.actions.declare_file(module_name + ".i")
    c_includes = "\n".join([
        "#include \"{}\"".format(header.path)
        for header in ctx.attr.lib[CcInfo].compilation_context.headers.to_list()
    ])
    swig_includes = c_includes.replace("#", "%")
    ctx.actions.expand_template(
        template = ctx.file._swig_interface_template,
        output = interface,
        substitutions = {
            "{moduleName}": module_name,
            "{CIncludes}": c_includes,
            "{swigIncludes}": swig_includes,
        }
    )
    return interface
