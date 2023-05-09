#
# Copyright (C) 2022 Vaticle
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

load("@io_bazel_rules_kotlin//kotlin:jvm.bzl", "kt_jvm_binary")

package(default_visibility = ["//visibility:public"])

sh_binary(
    name = "validate",
    srcs = ["validate_release_notes.sh"],
)

kt_jvm_binary(
    name = "create",
    srcs = glob(["*.kt"]),
    main_class = "com.vaticle.dependencies.tool.release.notes.NotesCreateKt",
    deps = [
        "@maven//:com_eclipsesource_minimal_json_minimal_json",
        "@maven//:com_google_http_client_google_http_client",
        "@maven//:org_zeroturnaround_zt_exec",
    ],
)
