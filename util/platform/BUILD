load("@bazel_skylib//lib:selects.bzl", "selects")

config_setting(
    name = "is_mac",
    constraint_values = [
        "@platforms//os:osx",
    ],
)

config_setting(
    name = "is_linux",
    constraint_values = [
        "@platforms//os:linux",
    ],
)

config_setting(
    name = "is_windows",
    constraint_values = [
        "@platforms//os:windows",
    ],
)

config_setting(
    name = "is_arm64",
    constraint_values = [
        "@platforms//cpu:arm64"
    ]
)

config_setting(
    name = "is_x86_64",
    constraint_values = [
        "@platforms//cpu:x86_64"
    ]
)

selects.config_setting_group(
    name = "is_mac_x86_64",
    match_all = [
        ":is_mac",
        ":is_x86_64"
    ]
)

selects.config_setting_group(
    name = "is_mac_arm64",
    match_all = [
        ":is_mac",
        ":is_arm64"
    ]
)

platform(
    name = "mac_arm64",
    constraint_values = [
        "@platforms//cpu:arm64",
        "@platforms//os:osx"
    ]
)

platform(
    name = "mac_x86_64",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:osx"
    ]
)

platform(
    name = "win_x86_64",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:windows"
    ]
)

platform(
    name = "linux_x86_64",
    constraint_values = [
        "@platforms//cpu:x86_64",
        "@platforms//os:linux"
    ]
)
