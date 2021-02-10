#!/usr/bin/env bash

set -ex

scp -oStrictHostKeyChecking=no -i ~/.ssh/id_rsa "${1}" "${2}"
