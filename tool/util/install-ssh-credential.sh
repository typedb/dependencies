#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -ex

bash -c 'echo $FACTORY_JOB_PRIVATE_KEY | base64 -d > ~/.ssh/id_rsa'
chmod 400 ~/.ssh/id_rsa
bash -c 'echo $FACTORY_JOB_PUBLIC_KEY | base64 -d >> ~/.ssh/authorized_keys'
