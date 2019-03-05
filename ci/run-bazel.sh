#!/bin/bash

if [[ -f ~/.config/gcloud/application_default_credentials.json ]]; then
    echo "Bazel will be executed with RBE support. This means the build is remotely executed and the cache will be re-used by subsequent CI jobs."
    CMD="$@ --config=rbe"
else
    echo "Bazel will be executed locally (without RBE support)."
    CMD="$@"
fi
echo "Executing $CMD"
$CMD