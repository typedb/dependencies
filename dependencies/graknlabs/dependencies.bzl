load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def graknlabs_dependencies():
    git_repository(
        name = "graknlabs_dependencies",
        remote = "https://github.com/graknlabs/dependencies",
        commit = "b6b375c63e78b763b916d8cf2420e9bd19a8edbf", # sync-marker: do not remove this comment, this is used for sync-dependencies by @graknlabs_dependencies
    )

def graknlabs_client_java():
     git_repository(
         name = "graknlabs_client_java",
         remote = "https://github.com/graknlabs/client-java",
         commit = "f1059ceefbdb97fc4ea16dadd88021b1b2816373"
     )


def graknlabs_grabl_tracing():
    git_repository(
        name = "graknlabs_grabl_tracing",
        remote = "https://github.com/graknlabs/grabl-tracing",
        commit = "38dc7e195c67a669b69b0bfedc8a7c6032201c2f"
    )

def graknlabs_common():
    git_repository(
        name = "graknlabs_common",
        remote = "https://github.com/graknlabs/common",
        commit = "c8f1859cf25f44f6748d198371a3721b1a888068",  # sync-marker: do not remove this comment, this is used for sync-common by @graknlabs_common
    )
