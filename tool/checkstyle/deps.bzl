#
# Copyright (C) 2018-present Vaticle
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

load("@bazel_tools//tools/build_defs/repo:jvm.bzl", "jvm_maven_import_external")


def deps(
    omit = [],
    versions = {
      "antlr_antlr": "2.7.7",
      "org_antlr_antlr4_runtime": "4.5.1-1",
      "com_puppycrawl_tools_checkstyle": "8.15",
      "commons_beanutils_commons_beanutils": "1.9.3",
      "info_picocli_picocli": "3.8.2",
      "commons_collections_commons_collections": "3.2.2",
      "com_google_guava_guava30jre": "30.1-jre",
      "org_slf4j_slf4j_api": "1.7.7",
      "org_slf4j_slf4j_jcl": "1.7.7",
    }
):
  if not "antlr_antlr" in omit:
    jvm_maven_import_external(
        name = "antlr_antlr",
        artifact = "antlr:antlr:" + versions["antlr_antlr"],
        artifact_sha256 = "88fbda4b912596b9f56e8e12e580cc954bacfb51776ecfddd3e18fc1cf56dc4c",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
  if not "org_antlr_antlr4_runtime" in omit:
    jvm_maven_import_external(
        name = "org_antlr_antlr4_runtime",
        artifact = "org.antlr:antlr4-runtime:" + versions["org_antlr_antlr4_runtime"],
        artifact_sha256 = "ffca72bc2a25bb2b0c80a58cee60530a78be17da739bb6c91a8c2e3584ca099e",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
  if not "com_puppycrawl_tools_checkstyle" in omit:
    jvm_maven_import_external(
        name = "com_puppycrawl_tools_checkstyle",
        artifact = "com.puppycrawl.tools:checkstyle:" + versions["com_puppycrawl_tools_checkstyle"],
        artifact_sha256 = "ac3602c4d50c3113b14614a6ac38ec03c63d9839e4316e057c4bb66d97183087",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
  if not "commons_beanutils_commons_beanutils" in omit:
    jvm_maven_import_external(
        name = "commons_beanutils_commons_beanutils",
        artifact = "commons-beanutils:commons-beanutils:" + versions["commons_beanutils_commons_beanutils"],
        artifact_sha256 = "c058e39c7c64203d3a448f3adb588cb03d6378ed808485618f26e137f29dae73",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
  if not "info_picocli_picocli" in omit:
    jvm_maven_import_external(
        name = "info_picocli_picocli",
        artifact = "info.picocli:picocli:" + versions["info_picocli_picocli"],
        artifact_sha256 = "b16786a3817530151ccc44ac44f1f803b9a1b4069e98c4d1ed2fc0ece12d6de7",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
  if not "commons_collections_commons_collections" in omit:
    jvm_maven_import_external(
        name = "commons_collections_commons_collections",
        artifact = "commons-collections:commons-collections:" + versions["commons_collections_commons_collections"],
        artifact_sha256 = "eeeae917917144a68a741d4c0dff66aa5c5c5fd85593ff217bced3fc8ca783b8",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
  if not "com_google_guava_guava30jre" in omit:
    jvm_maven_import_external(
        name = "com_google_guava_guava30jre",
        artifact = "com.google.guava:guava:" + versions["com_google_guava_guava30jre"],
        artifact_sha256 = "e6dd072f9d3fe02a4600688380bd422bdac184caf6fe2418cfdd0934f09432aa",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
  if not "org_slf4j_slf4j_api" in omit:
    jvm_maven_import_external(
        name = "org_slf4j_slf4j_api",
        artifact = "org.slf4j:slf4j-api:" + versions["org_slf4j_slf4j_api"],
        artifact_sha256 = "69980c038ca1b131926561591617d9c25fabfc7b29828af91597ca8570cf35fe",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
  if not "org_slf4j_slf4j_jcl" in omit:
    jvm_maven_import_external(
        name = "org_slf4j_slf4j_jcl",
        artifact = "org.slf4j:jcl-over-slf4j:" + versions["org_slf4j_slf4j_jcl"],
        artifact_sha256 = "c6472b5950e1c23202e567c6334e4832d1db46fad604b7a0d7af71d4a014bce2",
        server_urls = ["https://repo1.maven.org/maven2/"],
        licenses = ["notice"],
    )
