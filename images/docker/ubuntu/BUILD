#
# Copyright (C) 2022 Vaticle
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

load("//images/docker/ubuntu:deployment.bzl", deployment_docker = "deployment")

sh_library(
    name = "version-docker",
    srcs = ["version-docker.sh"],
)

sh_binary(
    name = "assemble-docker",
    srcs = ["assemble-docker.sh"],
    data = ["Dockerfile"],
    deps = [":version-docker"],
    args = ["$(location Dockerfile)", "$(location :version-docker)", deployment_docker["docker.organisation"], deployment_docker["docker.repository"]]
)

sh_binary(
    name = "deploy-docker",
    deps = [":version-docker"],
    srcs = ["deploy-docker.sh"],
    args = ["$(location :version-docker)", deployment_docker["docker.organisation"], deployment_docker["docker.repository"]]
)
