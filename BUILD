#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2018 Grakn Labs Ltd
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#

exports_files(["deployment.properties"], visibility = ["//visibility:public"])

# When a Bazel build or test is executed with RBE, it will be executed using the following platform.
# The platform is based on the standard rbe_ubuntu1604 from @bazel_toolchains,
# but with an additional setting dockerNetwork = standard because our tests need network access
platform(
    name = "rbe-ubuntu1604-network-standard",
    parents = ["@bazel_toolchains//configs/ubuntu16_04_clang/10.0.0/bazel_0.29.1/config:platform"],
    remote_execution_properties = """
        properties: {
            name: "container-image"
            value: "docker://gcr.io/grakn-dev/rbe_platform@sha256:c64a67d102e1842563f46c0be534a52e0138e5ec90bf74e2047471019e107bc6"
        }
        properties: {
          name: "dockerNetwork"
          value: "standard"
        }
        """,
)

py_library(
    name = "common",
    srcs = ["common.py"],
    visibility = ["//visibility:public"]
)