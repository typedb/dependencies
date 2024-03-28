#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

# TODO: transition over to repo-vaticle-com
exec gcloud compute ssh repo-grakn-ai --project grakn-dev --zone europe-west1-b -- docker container restart nexus
