#!/bin/bash

set -e

function install_dependencies() {
    echo "Installing rpmbuild..."
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        sudo apt-get update
        sudo apt-get install rpm
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install rpm
    else
        echo "Your platform does not have rpmbuild executable for it. Make sure you are using Linux/macOS".
        exit 1
    fi
}

install_dependencies

echo "Installing RBE credential..."
if [[ -n "$BAZEL_RBE_CREDENTIAL" ]]; then
    BAZEL_RBE_CREDENTIAL_LOCATION=~/.config/gcloud/application_default_credentials.json
    echo "An RBE credential is found and will be saved to $BAZEL_RBE_CREDENTIAL_LOCATION. Bazel will be executed with RBE support."
    mkdir -p ~/.config/gcloud/
    echo $BAZEL_RBE_CREDENTIAL > "$BAZEL_RBE_CREDENTIAL_LOCATION"
    echo "The RBE credential has been installed!"
else
    echo "No RBE credential found. Bazel will be executed locally without RBE support."
fi
