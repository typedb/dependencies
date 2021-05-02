def _expand_label(name):
    """
    Expands incomplete labels without target names into full ones, e.g.:
    "//pattern" -> "//pattern:pattern"
    """
    if ":" not in name:
        name = name + ":" + name[name.rfind("/")+1:]
    return name



def native_java_libraries(name, deps = [], mac_deps = [], linux_deps = [], windows_deps = [], native_libraries_deps = [], **kwargs):
    all_mac_deps = []
    for dep in deps + mac_deps:
        all_mac_deps.append(dep)
    for dep in native_libraries_deps:
        all_mac_deps.append(dep + "-mac")

    native.java_library(
        name = name + "-mac",
        deps = all_mac_deps,
        **kwargs,
    )

    all_linux_deps = []
    for dep in deps + linux_deps:
        all_linux_deps.append(dep)
    for dep in native_libraries_deps:
        all_linux_deps.append(dep + "-linux")

    native.java_library(
        name = name + "-linux",
        deps = all_linux_deps,
        **kwargs,
    )

    all_windows_deps = []
    for dep in deps + windows_deps:
        all_windows_deps.append(dep)
    for dep in native_libraries_deps:
        all_windows_deps.append(dep + "-windows")

    native.java_library(
        name = name + "-windows",
        deps = all_windows_deps,
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
         "@vaticle_dependencies//util/platform:is_mac": [name + "-mac"],
         "@vaticle_dependencies//util/platform:is_linux": [name + "-linux"],
         "@vaticle_dependencies//util/platform:is_windows": [name + "-windows"],
         "//conditions:default": [name + "-mac"],
     })
