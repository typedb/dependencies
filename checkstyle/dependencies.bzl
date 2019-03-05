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

def checkstyle(
    omit = [],
    versions = {
      "antlr_antlr": "2.7.7",
      "org_antlr_antlr4_runtime": "4.5.1-1",
      "com_puppycrawl_tools_checkstyle": "8.15",
      "commons_beanutils_commons_beanutils": "1.9.3",
      "info_picocli_picocli": "3.8.2",
      "commons_collections_commons_collections": "3.2.2",
      "com_google_guava_guava23": "23.0",
      "org_slf4j_slf4j_api": "1.7.7",
      "org_slf4j_slf4j_jcl": "1.7.7",
    }
):
  if not "antlr_antlr" in omit:
    native.maven_jar(
        name = "antlr_antlr",
        artifact = "antlr:antlr:" + versions["antlr_antlr"],
    )
  if not "org_antlr_antlr4_runtime" in omit:
    native.maven_jar(
        name = "org_antlr_antlr4_runtime",
        artifact = "org.antlr:antlr4-runtime:" + versions["org_antlr_antlr4_runtime"],
    )
  if not "com_puppycrawl_tools_checkstyle" in omit:
    native.maven_jar(
        name = "com_puppycrawl_tools_checkstyle",
        artifact = "com.puppycrawl.tools:checkstyle:" + versions["com_puppycrawl_tools_checkstyle"],
    )
  if not "commons_beanutils_commons_beanutils" in omit:
    native.maven_jar(
        name = "commons_beanutils_commons_beanutils",
        artifact = "commons-beanutils:commons-beanutils:" + versions["commons_beanutils_commons_beanutils"],
    )
  if not "info_picocli_picocli" in omit:
    native.maven_jar(
        name = "info_picocli_picocli",
        artifact = "info.picocli:picocli:" + versions["info_picocli_picocli"],
    )
  if not "commons_collections_commons_collections" in omit:
    native.maven_jar(
        name = "commons_collections_commons_collections",
        artifact = "commons-collections:commons-collections:" + versions["commons_collections_commons_collections"],
    )
  if not "com_google_guava_guava23" in omit:
    native.maven_jar(
        name = "com_google_guava_guava23",
        artifact = "com.google.guava:guava:" + versions["com_google_guava_guava23"],
    )
  if not "org_slf4j_slf4j_api" in omit:
    native.maven_jar(
        name = "org_slf4j_slf4j_api",
        artifact = "org.slf4j:slf4j-api:" + versions["org_slf4j_slf4j_api"],
    )
  if not "org_slf4j_slf4j_jcl" in omit:
    native.maven_jar(
        name = "org_slf4j_slf4j_jcl",
        artifact = "org.slf4j:jcl-over-slf4j:" + versions["org_slf4j_slf4j_jcl"],
    )
