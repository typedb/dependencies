#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

set -ex

max_attempts=100
attempt_counter=0

until [ -f "${1}" ]; do
    if [ ${attempt_counter} -eq ${max_attempts} ]; then
      echo "Error: max attempt of $max_attempts reached."
      exit 1
    fi

    echo "Waiting for file ${1} has been created (attempt $attempt_counter).";
    attempt_counter=$(($attempt_counter+1))
    sleep 3;
done
