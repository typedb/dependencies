# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def deps(patch = []):
    http_archive(
        name = "aspect_rules_js",
        sha256 = "e3e6c3d42491e2938f4239a3d04259a58adc83e21e352346ad4ef62f87e76125",
        strip_prefix = "rules_js-1.30.0",
        url = "https://github.com/aspect-build/rules_js/releases/download/v1.30.0/rules_js-v1.30.0.tar.gz",
    )

    http_archive(
        name = "aspect_rules_ts",
        sha256 = "4c3f34fff9f96ffc9c26635d8235a32a23a6797324486c7d23c1dfa477e8b451",
        strip_prefix = "rules_ts-1.4.5",
        url = "https://github.com/aspect-build/rules_ts/releases/download/v1.4.5/rules_ts-v1.4.5.tar.gz",
    )
