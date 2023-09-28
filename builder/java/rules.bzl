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
