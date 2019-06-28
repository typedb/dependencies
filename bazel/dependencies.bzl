#
# GRAKN.AI - THE KNOWLEDGE GRAPH
# Copyright (C) 2018 Grakn Labs Ltd
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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file", "http_jar")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

def bazel_common():
    git_repository(
        name="com_github_google_bazel_common",
        remote="https://github.com/graknlabs/bazel-common",
        commit="5cf83ccbb4b184f282380fe2c1f47b13336ffcdd",
    )

def bazel_toolchain():
    http_archive(
      name = "bazel_toolchains",
      sha256 = "70bb7ff38a2e93b192dbb07f42f5d974d934cd31ad091fa482c4f2e50ece9c51",
      strip_prefix = "bazel-toolchains-e703fbf6eac46761d58765b30030ed5501b49211",
      urls = [
        "https://github.com/bazelbuild/bazel-toolchains/archive/e703fbf6eac46761d58765b30030ed5501b49211.tar.gz",
      ],
    )

def bazel_deps():
    http_jar(
        name = "bazel_deps",
        urls = ["https://github.com/lolski/bazel-deps/releases/download/0.3/parseproject_deploy.jar"],
    )

def bazel_rules_docker():
    http_archive(
        name = "io_bazel_rules_docker",
        sha256 = "e6d8897e34d0a9564d3764b52354a8a614fd727df10fe13f3e06b6406b8acdd9",
        strip_prefix = "rules_docker-fb1ec3c13895d7723d5a784ba861629cc7392265",
        urls = ["https://github.com/bazelbuild/rules_docker/archive/fb1ec3c13895d7723d5a784ba861629cc7392265.tar.gz"],
    )

def bazel_rules_nodejs():
    git_repository(
        name = "build_bazel_rules_nodejs",
        remote = "https://github.com/graknlabs/rules_nodejs.git",
        commit = "bf925edc794ebaba1586fb3487d451f84edaf635",
    )

def bazel_rules_python():
    git_repository(
        name = "io_bazel_rules_python",
        remote = "https://github.com/bazelbuild/rules_python.git",
        commit = "e6399b601e2f72f74e5aa635993d69166784dde1",
    )

def buildifier():
    http_file(
        name = "buildifier",
        executable = True,
        sha256 = "d7d41def74991a34dfd2ac8a73804ff11c514c024a901f64ab07f45a3cf0cfef",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.11.1/buildifier"],
    )
    http_file(
        name = "buildifier_osx",
        executable = True,
        sha256 = "3cbd708ff77f36413cfaef89cd5790a1137da5dfc3d9b3b3ca3fac669fbc298b",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.11.1/buildifier.osx"],
    )

def buildozer():
    http_file(
        name = "buildozer",
        executable = True,
        sha256 = "3226cfd3ac706b48fe69fc4581c6c163ba5dfa71a752a44d3efca4ae489f1105",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.11.1/buildozer"],
    )
    http_file(
        name = "buildozer_osx",
        executable = True,
        sha256 = "48109a542da2ad4bf10e7df962514a58ac19a32033e2dae8e682938ed11f4775",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.11.1/buildozer.osx"],
    )

def unused_deps():
    http_file(
        name = "unused_deps",
        executable = True,
        sha256 = "59a7553f825e78bae9875e48d29e6dd09f9e80ecf40d16210c4ac95bab7ce29c",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.19.2/unused_deps"],
    )
    http_file(
        name = "unused_deps_osx",
        executable = True,
        sha256 = "e14f82cfddb9db4b18db91f438babb1b4702572aabfdbeb9b94e265c7f1c147d",
        urls = ["https://github.com/bazelbuild/buildtools/releases/download/0.19.2/unused_deps.osx"],
    )
