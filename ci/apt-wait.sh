#!/bin/bash

echo -n 'Waiting for the initial apt-get process to finish...'
init_wait=0
while [[ $init_wait -eq 0 ]]; do
  set +e
  ps -C apt-get > /dev/null
  init_wait=$?
  set -e
  echo -n '.'
  sleep 1
done
echo 'done.'