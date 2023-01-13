load("@rules_rust//crate_universe:defs.bzl", "crate", "crates_repository", "render_config")

def fetch_crates():
    crates_repository(
        name = "crates",
        cargo_lockfile = "@vaticle_dependencies//library/crates:Cargo.lock",
        lockfile = "@vaticle_dependencies//library/crates:cargo-bazel-lock.json",
        manifests = ["@vaticle_dependencies//library/crates:Cargo.toml"],
        annotations = {
            "librocksdb-sys": [crate.annotation(
                build_script_env = {"ROCKSDB_LIB_DIR": "./lib"},
            )],
        },
        # Setting the default package name to `""` forces the use of the macros defined in this repository
        # to always use the root package when looking for dependencies or aliases. This should be considered
        # optional as the repository also exposes alises for easy access to all dependencies.
        render_config = render_config(
            default_package_name = "",
        ),
    )
