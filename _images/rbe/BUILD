# When a Bazel build or test is executed with RBE, it will be executed using the following platform.
# The platform is based on the standard rbe_ubuntu1604 from @bazel_toolchains,
# but with an additional setting dockerNetwork = standard because our tests need network access
platform(
    name = "ubuntu-1604",
    parents = ["@bazel_toolchains//configs/ubuntu16_04_clang/11.0.0/bazel_3.0.0/config:platform"],
    remote_execution_properties = """
        properties: {
            name: "container-image"
            value: "docker://gcr.io/grakn-dev/rbe_platform@sha256:435403f84a20db7ac779bf2688dce6bd6463d62608c0731cfb944cd0b74b35d8"
        }
        properties: {
          name: "dockerNetwork"
          value: "standard"
        }
        """,
)
