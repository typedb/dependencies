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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_file")

def sonarcloud_dependencies():
    http_file(
        name = "sonarscanner_zip",
        urls = ["https://repo1.maven.org/maven2/org/sonarsource/scanner/cli/sonar-scanner-cli/3.3.0.1492/sonar-scanner-cli-3.3.0.1492.zip"]
    )
