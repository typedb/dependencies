# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


docker run -d -p 443:8443 -p 80:8081 --restart=on-failure --name nexus -v nexus-data:/nexus-data -e NEXUS_CONTEXT=/ sonatype/nexus3:3.33.0
