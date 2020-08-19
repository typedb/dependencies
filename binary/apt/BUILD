load("@graknlabs_bazel_distribution//apt:rules.bzl", "assemble_apt", "deploy_apt")
load("@graknlabs_bazel_distribution//common:rules.bzl", "assemble_targz")

assemble_apt(
    name = "assemble-linux-apt",
    package_name = "grakn-bin",
    maintainer = "Grakn Labs <community@grakn.ai>",
    description = "Grakn Core (binaries)",
    archives = ["//distribution:assemble-bash-targz"],
    installation_dir = "/opt/grakn/core/",
    empty_dirs = [
        "var/log/grakn/",
    ],
    depends = [
        "openjdk-8-jre"
    ],
    permissions = {
        "var/log/grakn/": "0777",
    },
    symlinks = {
        "usr/local/bin/grakn": "/opt/grakn/core/grakn",
        "opt/grakn/core/logs": "/var/log/grakn/",
    },
)

deploy_apt(
    name = "deploy-apt",
    target = ":assemble-linux-apt",
    deployment_properties = "//distribution:deployment.properties",
)