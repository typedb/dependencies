#
# Copyright (C) 2021 Vaticle
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

load("@io_bazel_rules_kotlin//kotlin:kotlin.bzl", "kt_jvm_binary")

kt_jvm_binary(
    name = "bump",
    srcs = ["Bump.kt"],
    main_class = "com.vaticle.dependencies.tool.release.version.BumpKt",
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json",
        "@maven//:com_google_http_client_google_http_client",
    ],
)
