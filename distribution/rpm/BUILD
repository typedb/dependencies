#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2019 Grakn Labs Ltd
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

load("@graknlabs_bazel_distribution//rpm:rules.bzl", "assemble_rpm", "deploy_rpm")

assemble_rpm(
    name = "assemble-linux-rpm",
    package_name = "grakn-bin",
    installation_dir = "/opt/grakn/core/",
    spec_file = ":grakn-bin.spec",
    empty_dirs = [
        "var/log/grakn/",
    ],
    archives = ["//distribution:assemble-bash-targz"],
    permissions = {
        "var/log/grakn/": "0777",
    },
    symlinks = {
        "usr/local/bin/grakn": "/opt/grakn/core/grakn",
        "opt/grakn/core/logs": "/var/log/grakn/",
    },
)

deploy_rpm(
    name = "deploy-rpm",
    target = ":assemble-linux-rpm",
    deployment_properties = "//distribution:deployment.properties",
)
