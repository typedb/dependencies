# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


_cloudsmith_public = {
    "release" : "cloudsmith://typedb/public-release",
    "snapshot" : "cloudsmith://typedb/public-snapshot"
}

_cloudsmith_private = {
    "release" : "cloudsmith://typedb/private-release",
    "snapshot" : "cloudsmith://typedb/private-snapshot"
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
        "release": "https://github.com/typedb/homebrew-tap/",
        "snapshot": "https://github.com/typedb/homebrew-tap-test/",
     },
    "crate" : {
        "release": "https://crates.io",
        "snapshot": "https://cargo.cloudsmith.io/typedb/public-snapshot",
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
    "nuget" : {
        "release": "https://api.nuget.org/v3/index.json",
        "snapshot": "https://nuget.cloudsmith.io/typedb/public-snapshot/v3/index.json",
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
