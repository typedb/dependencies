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

_TARGET_TYPES = {
    "rust_library": "lib",
    "rust_shared_library": "lib",
    "rust_static_library": "lib",
    "rust_binary": "bin",
    "rust_proc_macro": "lib",
    "rust_test": "test",
    "_build_script_run": "build"
}

CrateInfo = provider(fields = [
    "kind",        # str
    "crate_name",  # str
    "version",     # str
    "features",    # List[str]
    "deps",        # List[target]
    "build_deps",  # List[target]
])

CargoProjectInfo = provider(fields = [
    "manifest",    # File
    "sources",     # Map[relpath:str, File]
])

def _rust_cargo_project_aspect_impl(target, ctx):
    if ctx.rule.kind not in _TARGET_TYPES.keys():
        # not a crate
        return []

    crate_info = _crate_info(ctx, target)
    sources = [f for src in getattr(ctx.rule.attr, "srcs", []) + getattr(ctx.rule.attr, "compile_data", []) for f in src.files.to_list()]
    properties_file = _build_cargo_properties_file(target, ctx, sources, crate_info)

    output_groups = OutputGroupInfo(rust_cargo_properties = depset([properties_file]))
    providers = [crate_info, output_groups]

    if _should_generate_cargo_manifest(ctx, target):
        build_deps = []
        manifest_file = ctx.actions.declare_file(crate_info.crate_name + "/Cargo.toml")
        args = ["--properties", properties_file.path, "--output", manifest_file.path] + [f.path for f in build_deps]
        ctx.actions.run(
            inputs = build_deps + [properties_file],
            outputs = [manifest_file],
            executable = ctx.attr._manifest_writer.files_to_run.executable,
            arguments = args,
        )

        project_sources = {}

        for src in sources:
            src_path = _src_relpath(ctx, src)
            dst = ctx.actions.declare_file(crate_info.crate_name + "/" + src_path)
            _copy_to_bin(ctx, src, dst)
            project_sources[src_path] = dst

        workspace_sources = list(project_sources.values())
        for dep in crate_info.deps:
            if CargoProjectInfo in dep:
                dep_info = dep[CrateInfo]
                project_info = dep[CargoProjectInfo]
                dep_manifest = ctx.actions.declare_file(dep_info.crate_name + "/" + project_info.manifest.basename)
                workspace_sources.append(dep_manifest)
                _copy_to_bin(ctx, project_info.manifest, dep_manifest)
                for path, file in project_info.sources.items():
                    dst = ctx.actions.declare_file(dep_info.crate_name + "/" + path)
                    _copy_to_bin(ctx, file, dst)
                    workspace_sources.append(dst)

        cargo_project_info = CargoProjectInfo(
            manifest = manifest_file,
            sources = project_sources,
        )
        output_groups = OutputGroupInfo(
            rust_cargo_properties = depset([properties_file]),
            rust_cargo_project = depset([manifest_file] + workspace_sources),
        )
        providers = [crate_info, cargo_project_info, output_groups]

    return providers

rust_cargo_project_aspect = aspect(
    attr_aspects = ["deps", "proc_macro_deps", "crate"],
    implementation = _rust_cargo_project_aspect_impl,
    attrs = {
        "_manifest_writer" : attr.label(
            default = Label("@vaticle_dependencies//builder/rust/cargo:manifest-writer"),
            executable = True,
            cfg = "exec",
        )
    }
)

def _crate_info(ctx, target):
    if _is_universe_crate(target):
        crate_name = str(target.label).split(".")[0].rsplit("-", 1)[0].removeprefix("@crates__")
    else:
        crate_name = ctx.rule.attr.name
        for tag in ctx.rule.attr.tags:
            if tag.startswith("crate-name"):
                crate_name = tag.split("=")[1]
    return CrateInfo(
        kind = ctx.rule.kind,
        crate_name = crate_name,
        version = getattr(ctx.rule.attr, "version", "0.0.0"),
        features = getattr(ctx.rule.attr, "crate_features", []),
        deps = _crate_deps(ctx, target),
        build_deps = _crate_build_deps(ctx, target),
    )

def _crate_deps(ctx, target):
    return [dep for dep in _all_deps(ctx) if _TARGET_TYPES[dep[CrateInfo].kind] in ["bin", "lib"]]

def _crate_build_deps(ctx, target):
    return [dep for dep in _deps(ctx) if _TARGET_TYPES[dep[CrateInfo].kind] == "build"]

def _deps(ctx):
    return [dep for dep in getattr(ctx.rule.attr, "deps", []) if CrateInfo in dep]

def _all_deps(ctx):
    return [
        dep for dep in
        _deps(ctx) + getattr(ctx.rule.attr, "proc_macro_deps", []) + ([ctx.rule.attr.crate] if hasattr(ctx.rule.attr, "crate") and ctx.rule.attr.crate else [])
        if CrateInfo in dep
    ]

def _copy_to_bin(ctx, src, dst):
    ctx.actions.run_shell(
        inputs = [src],
        outputs = [dst],
        command = "cp -f '%s' '%s'" % (src.path, dst.path),
    )

def _should_generate_cargo_manifest(ctx, target):
    return (str(target.label).startswith("@vaticle") or str(target.label).startswith("//")) and \
        ctx.rule.kind in _TARGET_TYPES and _TARGET_TYPES[ctx.rule.kind] in ["bin", "lib", "test"]

def _is_universe_crate(target):
    return str(target.label).startswith("@crates__")

def _build_cargo_properties_file(target, ctx, source_files, crate_info):
    properties_file = ctx.actions.declare_file("%s.cargo.properties" % ctx.rule.attr.name)
    properties = _get_properties(target, ctx, source_files, crate_info)

    content = ""
    for prop in properties.items():
        content = content + ("%s: %s\n" % (prop[0], prop[1]))
    ctx.actions.write(
        output = properties_file,
        content = content
    )
    return properties_file

def _get_properties(target, ctx, source_files, crate_info):
    target_type = "build" if _looks_like_cargo_build_script(target) else _TARGET_TYPES[ctx.rule.kind]

    properties = {}
    properties["name"] = crate_info.crate_name
    properties["type"] = target_type
    properties["label"] = target.label
    properties["version"] = crate_info.version
    if target_type in ["bin", "lib"]:
        properties["edition"] = ctx.rule.attr.edition or "2021"
        properties["root.path"] = _target_root_path(target)
        entry_point_file = _entry_point_file(target, ctx, source_files)
        properties["entry.point.path"] = _src_relpath(ctx, entry_point_file)
        properties["build.deps"] = ",".join(_crate_build_deps_info(crate_info))
    for dep in _crate_deps_info(crate_info).items():
        properties["deps." + dep[0]] = dep[1]
    return properties

def _crate_deps_info(crate_info):
    deps_info = {}
    for dependency in crate_info.deps:
        dependency_info = dependency[CrateInfo]
        if _is_universe_crate(dependency):
            location = "version=%s" % dependency_info.version
        else:
            location = "path=../%s" % dependency_info.crate_name
        features = ",".join(dependency_info.features)
        info = location + (";features=%s" % features if features else "")
        deps_info[dependency_info.crate_name] = info
    return deps_info

def _crate_build_deps_info(crate_info):
    return [build_dep[CrateInfo].crate_name for build_dep in crate_info.build_deps]

def _looks_like_cargo_build_script(target):
    return str(target.label).endswith("_")

def _target_root_path(target):
    return str(target.label).split("//")[1].split(":")[0] if "//" in str(target.label) else ""

def _entry_point_file(target, ctx, source_files):
    if getattr(ctx.rule.attr, "crate_root", None):
        return ctx.rule.attr.crate_root.files.to_list()[0]
    else:
        return _find_entry_point_in_sources(target, ctx, source_files)

def _find_entry_point_in_sources(target, ctx, source_files):
    standard_entry_point_name = "main.rs" if ctx.rule.kind == "rust_binary" else "lib.rs"
    alternative_entry_point_name = "%s.rs" % ctx.rule.attr.name

    standard_entry_points = [f for f in source_files if f.basename == standard_entry_point_name]
    if len(standard_entry_points) == 1:
        return standard_entry_points[0]
    elif len(standard_entry_points) > 1:
        fail("cannot determine entry point for %s target '%s': multiple files named '%s' found in srcs, and no explicit crate_root" % (ctx.rule.kind, target.label.name, standard_entry_point_name))

    alternative_entry_points = [f for f in source_files if f.basename == alternative_entry_point_name]
    if len(alternative_entry_points) == 1:
        return alternative_entry_points[0]
    elif len(alternative_entry_points) > 1:
        fail("cannot determine entry point for %s target '%s': multiple files named '%s' found in srcs, and no explicit crate_root" % (ctx.rule.kind, target.label.name, alternative_entry_point_name))

    fail("cannot determine entry point for %s target '%s': no files named '%s' or '%s' found in srcs, and no explicit crate_root" % (ctx.rule.kind, target.label.name, standard_entry_point_name, alternative_entry_point_name))

def _src_relpath(ctx, src):
    path = src.path
    if "external" in path:
        x = path.find("external")
        path = path[x:].split("/", 2)[2]
    path_elements = path.split("/")
    for el in ctx.build_file_path.split("/")[:-1]:
        if el != path_elements[0]:
            print("ACHTUNG")
            break
        path_elements = path_elements[1:]
    return "/".join(path_elements)
