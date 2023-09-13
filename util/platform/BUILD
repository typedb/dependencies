LINUX = [
    "@platforms//os:linux",
]

MAC = [
    "@platforms//os:osx",
]

WINDOWS = [
    "@platforms//os:windows",
]

AARCH64 = [
    "@platforms//cpu:aarch64",
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
    name = "is_aarch64",
    constraint_values = AARCH64,
)

config_setting(
    name = "is_x86_64",
    constraint_values = X86_64,
)

config_setting(
    name = "is_linux_aarch64",
    constraint_values = LINUX + AARCH64,
)

config_setting(
    name = "is_linux_x86_64",
    constraint_values = LINUX + X86_64,
)

config_setting(
    name = "is_mac_aarch64",
    constraint_values = MAC + AARCH64,
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
    name = "linux_aarch64",
    constraint_values = LINUX + AARCH64,
)

platform(
    name = "linux_x86_64",
    constraint_values = LINUX + X86_64,
)

platform(
    name = "mac_aarch64",
    constraint_values = MAC + AARCH64,
)

platform(
    name = "mac_x86_64",
    constraint_values = MAC + X86_64,
)

platform(
    name = "win_x86_64",
    constraint_values = WINDOWS + X86_64,
)
