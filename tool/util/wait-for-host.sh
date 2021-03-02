#!/usr/bin/env bash

set -e

max_attempts=100
attempt_counter=0

until ping -q -c 1 "${1}" -w 2; do
    if [ ${attempt_counter} -eq ${max_attempts} ]; then
      echo "Error: max attempt of $max_attempts reached."
      exit 1
    fi

    echo "Waiting for host ${1}: (attempt $attempt_counter).";
    attempt_counter=$(($attempt_counter+1))
    sleep 3;
done

echo "Waiting for host: ${1} is available after $(($attempt_counter+1)) attemps.";
