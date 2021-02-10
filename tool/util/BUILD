#
# Copyright (C) 2021 Grakn Labs
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

sh_binary(
    name = "restart-repo-container",
    srcs = ["restart-repo-container.sh"],
)

sh_binary(
    name = "ssh-repo-container",
    srcs = ["ssh-repo-container.sh"],
)

sh_binary(
    name = "ssh-repo-machine",
    srcs = ["ssh-repo-machine.sh"],
)

sh_binary(
    name = "install-ssh-credential",
    srcs = [":install-ssh-credential.sh"],
)

sh_binary(
    name = "wait-for-file",
    srcs = [":wait-for-file.sh"],
)

sh_binary(
    name = "transfer-file",
    srcs = [":transfer-file.sh"],
)

sh_binary(
    name = "create-systemd-service",
    srcs = [":create-systemd-service.sh"],
    data = [":systemd-service-template.txt"]
)
