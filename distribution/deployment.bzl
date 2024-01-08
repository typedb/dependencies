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

_cloudsmith_public = {
    "release" : "cloudsmith://typedb/public-release",
    "snapshot" : "cloudsmith://typedb/public-snapshot"
}

_cloudsmith_private = {
    "release" : "cloudsmith://typedb/private-release",
    "snapshot" : "cloudsmith://typedb/public-snapshot"
}

deployment = {
    "apt" : {
        "release" : {
            "upload" : _cloudsmith_public["release"],
        },
        "snapshot": {
            "upload" : _cloudsmith_public["snapshot"],
        }
    },
    "artifact" : {
        "release" : {
            "upload" : _cloudsmith_public["release"],
            "download": "https://repo.typedb.com/public/public-release/raw/"
        },
        "snapshot": {
            "upload" : _cloudsmith_public["snapshot"],
            "download" : "https://repo.typedb.com/public/public-snapshot/raw/",
        }
    },
    "brew" : {
        "release": "https://github.com/vaticle/homebrew-tap/",
        "snapshot": "https://github.com/vaticle/homebrew-tap-test/",
     },
    "crate" : {
        "release": "https://crates.io",
        "snapshot": "https://cargo.cloudsmith.io/typedb/public-snapshot", # trailing / breaks the url
    },
    "maven" : {
        "release" : {
            "upload" : _cloudsmith_public["release"],
            "download": "https://repo.typedb.com/public/public-release/maven/",
        },
        "snapshot": {
            "upload" : _cloudsmith_public["snapshot"],
            "download": "https://repo.typedb.com/public/public-snapshot/maven/",
        }
    },
    "npm" : {
        "release": "https://registry.npmjs.org/",
        "snapshot": "https://npm.cloudsmith.io/typedb/public-snapshot/",
    },
    "pypi" : {
        "release": "https://upload.pypi.org/legacy/",
        "snapshot": "https://python.cloudsmith.io/typedb/public-snapshot/",
    },
}

deployment_private = {
    "artifact" : {
        "release" : {
            "upload" : _cloudsmith_private["release"],
            "download": "https://repo.typedb.com/basic/private-release/raw/"
        },
        "snapshot": {
            "upload" : _cloudsmith_private["snapshot"],
            "download": "https://repo.typedb.com/basic/private-snapshot/raw/"
        }
    },
    "helm" :  {
        "release" : {
             "upload" : _cloudsmith_private["release"],
             "download": "https://repo.typedb.com/basic/private-release/helm/charts/"
        },
        "snapshot": {
             "upload" : _cloudsmith_private["snapshot"],
             "download" : "https://repo.typedb.com/basic/private-snapshot/helm/charts/",
        }
    }
}
