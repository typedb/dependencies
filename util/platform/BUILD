LINUX = [
    "@platforms//os:linux",
]

MAC = [
    "@platforms//os:osx",
]

WINDOWS = [
    "@platforms//os:windows",
]

ARM64 = [
    "@platforms//cpu:arm64",
]

X86_64 = [
    "@platforms//cpu:x86_64",
]


config_setting(
    name = "is_linux",
    constraint_values = LINUX,
)

config_setting(
    name = "is_mac",
    constraint_values = MAC,
)

config_setting(
    name = "is_windows",
    constraint_values = WINDOWS,
)

config_setting(
    name = "is_arm64",
    constraint_values = ARM64,
)

config_setting(
    name = "is_x86_64",
    constraint_values = X86_64,
)

config_setting(
    name = "is_linux_arm64",
    constraint_values = LINUX + ARM64,
)

config_setting(
    name = "is_linux_x86_64",
    constraint_values = LINUX + X86_64,
)

config_setting(
    name = "is_mac_arm64",
    constraint_values = MAC + ARM64,
)

config_setting(
    name = "is_mac_x86_64",
    constraint_values = MAC + X86_64,
)

config_setting(
    name = "is_win_x86_64",
    constraint_values = WINDOWS + X86_64,
)

platform(
    name = "linux_arm64",
    constraint_values = LINUX + ARM64,
)

platform(
    name = "linux_x86_64",
    constraint_values = LINUX + X86_64,
)

platform(
    name = "mac_arm64",
    constraint_values = MAC + ARM64,
)

platform(
    name = "mac_x86_64",
    constraint_values = MAC + X86_64,
)

platform(
    name = "win_x86_64",
    constraint_values = WINDOWS + X86_64,
)
