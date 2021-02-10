#!/usr/bin/env bash

service=/tmp/"${1}".service

cp ci/systemd-service-template.txt $service

sed -i -e "s/DESCRIPTION_PLACEHOLDER/${1}/g" $service
sed -i -e "s/EXEC_START_PLACEHOLDER/${2}/g" $service

cat $service

sudo mv $service /etc/systemd/system/
