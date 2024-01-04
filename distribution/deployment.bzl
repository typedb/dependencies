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

deployment = {
    "artifact.release" : "https://repo.typedb.com/public/public/raw/",
    "artifact.snapshot" : "https://repo.typedb.com/public/public-snapshot/raw/",

    "cloudsmith.release": "cloudsmith://typedb/public",
    "cloudsmith.snapshot": "cloudsmith://typedb/public-snapshot",

    "brew.release": "https://github.com/vaticle/homebrew-tap/",
    "brew.snapshot": "https://github.com/vaticle/homebrew-tap-test/",

    "crate.release": "https://crates.io",
    "crate.snapshot": "https://cargo.cloudsmith.io/typedb/public-snapshot", # trailing / breaks the url

    "maven.release": "https://repo.typedb.com/public/public/maven/",
    "maven.snapshot": "https://repo.typedb.com/public/public-snapshot/maven/",

    "npm.release": "https://registry.npmjs.org/",
    "npm.snapshot": "https://npm.cloudsmith.io/typedb/public-snapshot/",

    "pypi.release": "https://upload.pypi.org/legacy/",
    "pypi.snapshot": "https://python.cloudsmith.io/typedb/public-snapshot/",
}

deployment_private = {
    "cloudsmith.release": "cloudsmith://typedb/private",
    "cloudsmith.snapshot": "cloudsmith://typedb/private-snapshot",

    "artifact.release" : "https://repo.typedb.com/{entitlement_token}/private/raw/",
    "artifact.snapshot" : "https://repo.typedb.com/{entitlement_token}/private-snapshot/raw",
}
