#!/usr/bin/env bash

service=/tmp/"${2}".service

cp $1 $service

sed -i -e "s/DESCRIPTION_PLACEHOLDER/${2}/g" $service
sed -i -e "s/EXEC_START_PLACEHOLDER/${3}/g" $service

cat $service

sudo mv $service /etc/systemd/system/
