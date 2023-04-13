#!/bin/bash

set -e

if [[ -n "$BAZEL_CACHE_CREDENTIAL" ]] && [[ -n "$BAZEL_CACHE_URL" ]]; then
    echo "Installing remote cache credential..."
    BAZEL_CACHE_CREDENTIAL_LOCATION=./credential.json
    echo "A remote cache credential is found and will be saved to $BAZEL_CACHE_CREDENTIAL_LOCATION. Artifact and test results will be cached remotely."
    echo "$BAZEL_CACHE_CREDENTIAL" | base64 -d > $BAZEL_CACHE_CREDENTIAL_LOCATION
    ( echo "build --remote_cache=$BAZEL_CACHE_URL --google_credentials=$BAZEL_CACHE_CREDENTIAL_LOCATION"; echo "test --cache_test_results=no" ) >> ./.bazel-remote-cache.rc
    echo "The remote cache has been installed!"
else
    echo "The remote cache was not installed."
    echo "The environment variables \$BAZEL_CACHE_CREDENTIAL and \$BAZEL_CACHE_URL must both be set for remote cache installation."
fi
