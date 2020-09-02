#
# Copyright (C) 2020 Grakn Labs
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

package(default_visibility = ["//visibility:public"])

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
