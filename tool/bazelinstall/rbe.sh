#!/bin/bash

set -e

if [[ -n "$BAZEL_CACHE_URL" ]]; then
    echo "Installing remote cache credential..."
    BAZEL_CACHE_CREDENTIAL=/opt/credentials/
    echo "A remote cache credential is found and will be saved to $BAZEL_CACHE_CREDENTIAL. Artifact and test results will be cached remotely."
    sudo mkdir -p $BAZEL_CACHE_CREDENTIAL && sudo chmod a+rwx $BAZEL_CACHE_CREDENTIAL
    ( echo "build --remote_cache=$BAZEL_CACHE_URL"; echo "test --remote_cache=$BAZEL_CACHE_URL"; echo "run --remote_cache=$BAZEL_CACHE_URL" ) >> "$BAZEL_CACHE_CREDENTIAL/bazel-remote-cache.rc"
    echo "The RBE credential has been installed!"
    echo "Configuring Python..."
    pyenv global system system
else
    echo "No RBE credential found. Bazel will be executed locally without RBE support."
    echo "Configuring Python..."
    # uses system version of python, according to the image that is set
    pyenv global system system
fi
