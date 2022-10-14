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

def _target_root_path(target):
    return str(target.label).split("//")[1].split(":")[0] if "//" in str(target.label) else ""

def _entry_point(target, ctx, source_files):
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

def _is_raze_crate(rust_target):
    return str(rust_target.label).startswith("@raze__")

def _dep_path(current_target, dep_target):
    if str(current_target.label).split("//")[0] == str(dep_target.label).split("//")[0]:
        return _dep_path_same_repo(current_target, dep_target)
    else:
        return _dep_path_external_repo(dep_target)

def _dep_path_same_repo(current_target, dep_target):
    # examples:
    # (//lib1:lib1, //lib2/internal:internal) --> ../lib2/internal
    # (@extern_repo//:root, @extern_repo//lib2:lib2 --> lib2
    return _dep_path_double_dots(current_target) + str(dep_target.label).split("//")[1].split(":")[0]

def _dep_path_external_repo(dep_target):
    # example: (@extern_repo//lib2/exported:exported) --> /private/var/tmp/_bazel_root/123456abc/extern_repo/lib2/exported
    return "{external}/" + str(dep_target.label)[1:].split("//")[0] + "/" + str(dep_target.label).split("//")[1].split(":")[0]

def _dep_path_double_dots(current_target):
    # for simplicity, insert enough double dots to resolve to the workspace root
    double_dots = ""
    if str(current_target.label).count("/") > 2:
        for i in range(str(current_target.label).count("/") - 1):
            double_dots = double_dots + "../"
    elif str(current_target.label).count("/") < 2:
        fail("cannot find the path of dependency '%s' as it does not look like a valid target label (not enough slashes)" % current_target.label)
    else:
        if len(str(current_target.label).split("//")[1].split(":")[0]):
            double_dots = "../"
    return double_dots

_TARGET_TYPES = {
    "rust_library": "lib",
    "rust_binary": "bin",
    "rust_proc_macro": "lib",
    "rust_test": "test"
}

def _deps_info(ctx, target):
    deps_info = {}
    all_deps = getattr(ctx.rule.attr, "deps", []) + getattr(ctx.rule.attr, "proc_macro_deps", []) + ([ctx.rule.attr.crate] if hasattr(ctx.rule.attr, "crate") and ctx.rule.attr.crate else [])
    for dependency in all_deps:
        if not _should_generate_dep_info(dependency):
            continue
        dep_info = dependency.cargo_sync_info
        features_str = ",".join(dep_info.features)
        if _is_raze_crate(dependency):
            deps_info[dependency.cargo_sync_info.name] = "version=%s;features=%s" % (dep_info.version, features_str) if features_str else "version=%s" % dep_info.version
        else:
            path = _dep_path(target, dependency)
            deps_info[dependency.cargo_sync_info.name] = "path=%s;features=%s" % (path, features_str) if features_str else "path=%s" % path
    return deps_info

def _should_generate_dep_info(dependency):
    return dependency.kind in ["rust_binary", "rust_library", "rust_proc_macro"]

def _cargo_sync_info(ctx, target):
    crate_name = ctx.rule.attr.name
    for tag in ctx.rule.attr.tags:
        if tag.startswith("crate-name"):
            crate_name = tag.split("=")[1]

    return struct(
        name = crate_name,
        version = getattr(ctx.rule.attr, "version", "0.0.0"),
        features = getattr(ctx.rule.attr, "crate_features", []),
        deps = _deps_info(ctx, target),
    )

def _cargo_sync_props(target, ctx, source_files, sync_info):
    props = {}
    target_type = _TARGET_TYPES[ctx.rule.kind]

    props["name"] = sync_info.name
    props["type"] = target_type
    props["version"] = sync_info.version
    props["edition"] = ctx.rule.attr.edition or "2021"
    if target_type != "test":
        props["root.path"] = _target_root_path(target)
        entry_point = _entry_point(target, ctx, source_files)
        props["entry.point.path"] = entry_point.short_path
        props["sources.are.generated"] = not entry_point.is_source
    for dep in sync_info.deps.items():
        props["deps." + dep[0]] = dep[1]
    return props

def _build_cargo_sync_props_file(target, ctx, source_files, sync_info):
    props_file = ctx.actions.declare_file("%s.cargo-sync.properties" % ctx.rule.attr.name)
    props = _cargo_sync_props(target, ctx, source_files, sync_info)

    content = ""
    for prop in props.items():
        content = content + ("%s: %s\n" % (prop[0], prop[1]))
    ctx.actions.write(
        output = props_file,
        content = content
    )
    return props_file

def _cargo_sync_aspect_impl(target, ctx):
    if ctx.rule.kind not in ["rust_binary", "rust_library", "rust_proc_macro", "rust_test"]:
        return struct(kind = ctx.rule.kind)

    sources = [f for src in getattr(ctx.rule.attr, "srcs", []) for f in src.files.to_list()]
    sync_info = _cargo_sync_info(ctx, target)
    sync_props_file = _build_cargo_sync_props_file(target, ctx, sources, sync_info)

    return struct(
        kind = ctx.rule.kind,
        cargo_sync_info = sync_info,
        output_groups = {"cargo-sync-props": depset([sync_props_file])}
    )

cargo_sync_aspect = aspect(
    attr_aspects = ["deps", "proc_macro_deps", "crate"],
    implementation = _cargo_sync_aspect_impl,
)
