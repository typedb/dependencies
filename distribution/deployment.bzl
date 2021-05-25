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

deployment = {
    "apt.snapshot": "https://repo.vaticle.com/repository/apt-snapshot/",
    "apt.release": "https://repo.vaticle.com/repository/apt/",

    "brew.snapshot": "https://github.com/vaticle/homebrew-tap-test/",
    "brew.release": "https://github.com/vaticle/homebrew-tap/",

    "maven.snapshot": "https://repo.vaticle.com/repository/maven-snapshot/",
    "maven.release": "https://repo.vaticle.com/repository/maven/",

    "pypi.release": "https://upload.pypi.org/legacy/",
    "pypi.snapshot": "https://repo.vaticle.com/repository/pypi-snapshot/",

    "npm.release": "https://registry.npmjs.org/",
    "npm.snapshot": "https://repo.vaticle.com/repository/npm-snapshot/",

    "rpm.snapshot": "https://repo.vaticle.com/repository/rpm-snapshot/",
    "rpm.release": "https://repo.vaticle.com/repository/rpm/",

    "artifact.snapshot": "https://repo.vaticle.com/repository/artifact-snapshot",
    "artifact.release": "https://repo.vaticle.com/repository/artifact",
}

deployment_private = {
    "npm.release": "https://repo.vaticle.com/repository/npm-private/",

    "artifact.snapshot": "https://repo.vaticle.com/repository/private-artifact-snapshot",
    "artifact.release": "https://repo.vaticle.com/repository/private-artifact",
}
