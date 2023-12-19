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

def _expand_label(name):
    """
    Expands incomplete labels without target names into full ones, e.g.:
    "//pattern" -> "//pattern:pattern"
    """
    if ":" not in name:
        name = name + ":" + name[name.rfind("/")+1:]
    return name



def native_java_libraries(
        name,
        deps = [],
        linux_arm64_deps = [],
        linux_x86_64_deps = [],
        mac_arm64_deps = [],
        mac_x86_64_deps = [],
        windows_x86_64_deps = [],
        runtime_deps = [],
        linux_arm64_runtime_deps = [],
        linux_x86_64_runtime_deps = [],
        mac_arm64_runtime_deps = [],
        mac_x86_64_runtime_deps = [],
        windows_x86_64_runtime_deps = [],
        native_libraries_deps = [],
        **kwargs
):
    all_linux_arm64_deps = deps + linux_arm64_deps
    all_linux_x86_64_deps = deps + linux_x86_64_deps
    all_mac_arm64_deps = deps + mac_arm64_deps
    all_mac_x86_64_deps = deps + mac_x86_64_deps
    all_windows_x86_64_deps = deps + windows_x86_64_deps

    for native_libraries_dep in native_libraries_deps:
        all_linux_arm64_deps.append(native_libraries_dep + "-linux-arm64")
        all_linux_x86_64_deps.append(native_libraries_dep + "-linux-x86_64")
        all_mac_arm64_deps.append(native_libraries_dep + "-mac-arm64")
        all_mac_x86_64_deps.append(native_libraries_dep + "-mac-x86_64")
        all_windows_x86_64_deps.append(native_libraries_dep + "-windows-x86_64")

    all_linux_arm64_runtime_deps = runtime_deps + linux_arm64_runtime_deps
    all_linux_x86_64_runtime_deps = runtime_deps + linux_x86_64_runtime_deps
    all_mac_arm64_runtime_deps = runtime_deps + mac_arm64_runtime_deps
    all_mac_x86_64_runtime_deps = runtime_deps + mac_x86_64_runtime_deps
    all_windows_x86_64_runtime_deps = runtime_deps + windows_x86_64_runtime_deps

    native.java_library(
        name = name + "-linux-arm64",
        deps = all_linux_arm64_deps,
        runtime_deps = all_linux_arm64_runtime_deps,
        **kwargs,
    )
    native.java_library(
        name = name + "-linux-x86_64",
        deps = all_linux_x86_64_deps,
        runtime_deps = all_linux_x86_64_runtime_deps,
        **kwargs,
    )
    native.java_library(
        name = name + "-mac-arm64",
        deps = all_mac_arm64_deps,
        runtime_deps = all_mac_arm64_runtime_deps,
        **kwargs,
    )
    native.java_library(
        name = name + "-mac-x86_64",
        deps = all_mac_x86_64_deps,
        runtime_deps = all_mac_x86_64_runtime_deps,
        **kwargs,
    )
    native.java_library(
        name = name + "-windows-x86_64",
        deps = all_windows_x86_64_deps,
        runtime_deps = all_windows_x86_64_runtime_deps,
        **kwargs,
    )


def host_compatible_java_library(name, deps = [], native_libraries_deps = [], **kwargs):
    native_deps = []
    for dep in native_libraries_deps:
        native_deps = native_deps + native_dep_for_host_platform(dep)

    native.java_library(
        name = name,
        deps = deps + native_deps,
        **kwargs
    )


def host_compatible_java_test(name, deps = [], native_libraries_deps = [], **kwargs):
    native_deps = []
    for dep in native_libraries_deps:
        native_deps = native_deps + native_dep_for_host_platform(dep)

    native.java_test(
       name = name,
       deps = deps + native_deps,
       **kwargs,
   )


def native_dep_for_host_platform(name):
    name = _expand_label(name)
    return select({
         "@vaticle_bazel_distribution//platform:is_linux_arm64": [name + "-linux-arm64"],
         "@vaticle_bazel_distribution//platform:is_linux_x86_64": [name + "-linux-x86_64"],
         "@vaticle_bazel_distribution//platform:is_mac_arm64": [name + "-mac-arm64"],
         "@vaticle_bazel_distribution//platform:is_mac_x86_64": [name + "-mac-x86_64"],
         "@vaticle_bazel_distribution//platform:is_windows": [name + "-windows"],
         "//conditions:default": ["INVALID"],
     })

def typedb_java_test(name, server_artifacts, console_artifacts = {},
                      native_libraries_deps = [], deps = [], classpath_resources = [], data = [], args = [], **kwargs):
    native_server_artifact_paths, native_server_artifact_labels = native_artifact_paths_and_labels(server_artifacts)
    native_console_artifact_paths, native_console_artifact_labels = native_artifact_paths_and_labels(console_artifacts, mandatory = False)
    native_dependencies = get_native_dependencies(native_libraries_deps)

    native.java_test(
        name = name,
        deps = depset(deps).to_list() + native_dependencies,
        classpath_resources = depset(classpath_resources).to_list(),
        data = data + select(native_server_artifact_labels) + (select(native_console_artifact_labels) if native_console_artifact_labels else []),
        args = ["--server"] + select(native_server_artifact_paths) + ((["--console"] + select(native_console_artifact_paths)) if native_console_artifact_paths else []) + args,
        **kwargs
    )

def typedb_kt_test(name, server_artifacts, console_artifacts = {},
                        native_libraries_deps = [], deps = [], data = [], args = [], **kwargs):
    native_server_artifact_paths, native_server_artifact_labels = native_artifact_paths_and_labels(server_artifacts)
    native_console_artifact_paths, native_console_artifact_labels = native_artifact_paths_and_labels(console_artifacts, mandatory = False)
    native_dependencies = get_native_dependencies(native_libraries_deps)

    kt_jvm_test(
        name = name,
        deps = depset(deps).to_list() + native_dependencies,
        data = data + select(native_server_artifact_labels) + (select(native_console_artifact_labels) if native_console_artifact_labels else []),
        args = ["--server"] + select(native_server_artifact_paths) + ((["--console"] + select(native_console_artifact_paths)) if native_console_artifact_paths else []) + args,
        **kwargs
    )

def get_native_dependencies(native_libraries_deps):
    native_dependencies = []
    for dep in native_libraries_deps:
       native_dependencies = native_dependencies + native_dep_for_host_platform(dep)
    return native_dependencies


def native_artifact_paths_and_labels(native_artifacts, mandatory = True):
    if native_artifacts:
        native_artifact_paths = {}
        native_artifact_labels = {}
        for key in native_artifacts.keys():
            native_artifact_labels[key] = [ native_artifacts[key] ]
            native_artifact_paths[key] = [ "$(location {})".format(native_artifacts[key]) ]
        return native_artifact_paths, native_artifact_labels
    elif mandatory:
        fail("Mandatory artifacts weren't available.")
    else:
        return [], []


def native_typedb_artifact(name, native_artifacts, output, **kwargs):
    native.genrule(
        name = name,
        outs = [output],
        srcs = select(native_artifacts, no_match_error = "There is no TypeDB artifact compatible with this operating system."),
        cmd = "read -a srcs <<< '$(SRCS)' && read -a outs <<< '$(OUTS)' && cp $${srcs[0]} $${outs[0]} && echo $${outs[0]}",
        **kwargs
    )
