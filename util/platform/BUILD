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