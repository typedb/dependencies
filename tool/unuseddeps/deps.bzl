# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def deps():
    http_file(
        name = "unused_deps_mac",
        urls = ["https://repo.typedb.com/public/public-tools/raw/files/unused_deps-mac-7e793330b31d465f6bffe101ace2ab25d75e2eec"],
        executable = True
    )
    http_file(
        name = "unused_deps_linux",
        urls = ["https://repo.typedb.com/public/public-tools/raw/files/unused_deps-linux-7e793330b31d465f6bffe101ace2ab25d75e2eec"],
        executable = True
    )
    http_file(
        name = "buildozer_mac",
        urls = ["https://repo.typedb.com/public/public-tools/raw/files/buildozer-mac-7e793330b31d465f6bffe101ace2ab25d75e2eec"],
        executable = True
    )
    http_file(
        name = "buildozer_linux",
        urls = ["https://repo.typedb.com/public/public-tools/raw/files/buildozer-linux-7e793330b31d465f6bffe101ace2ab25d75e2eec"],
        executable = True
    )
