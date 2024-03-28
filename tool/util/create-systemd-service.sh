#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

service=/tmp/"${2}".service

cp $1 $service

sed -i -e "s/DESCRIPTION_PLACEHOLDER/${2}/g" $service
sed -i -e "s/EXEC_START_PLACEHOLDER/${3}/g" $service

cat $service

sudo mv $service /etc/systemd/system/
