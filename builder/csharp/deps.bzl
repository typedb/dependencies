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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps(use_patched_version=False):
    http_archive(
        name = "rules_dotnet",
        sha256 = "09021aa1d8a63395cd072e384cd560612e713f35a448da43a7e89087787aadc0",
        strip_prefix = "rules_dotnet-0.13.0",
        url = "https://github.com/bazelbuild/rules_dotnet/releases/download/v0.13.0/rules_dotnet-v0.13.0.tar.gz",
    )
