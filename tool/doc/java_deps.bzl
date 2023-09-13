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

def deps():
    http_archive(
        name = "google_bazel_common",
        sha256 = "8ba02686ad2c9972ab31539bcbda7674d0b46f2ceb71aee417d2cf46d445ad4f",
        strip_prefix = "bazel-common-c805fdbef7a7927606a2a48e08683952f58a2b71",
        urls = ["https://github.com/google/bazel-common/archive/c805fdbef7a7927606a2a48e08683952f58a2b71.zip"],
    )
