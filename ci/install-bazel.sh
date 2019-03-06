#!/bin/bash

############################
#      install bazel       #
############################

echo "Installing Bazel..."
curl -OL https://github.com/bazelbuild/bazel/releases/download/0.20.0/bazel-0.20.0-installer-linux-x86_64.sh
chmod +x bazel-0.20.0-installer-linux-x86_64.sh
sudo ./bazel-0.20.0-installer-linux-x86_64.sh
echo "Bazel has been installed!"


############################
#  install RBE credential  #
############################

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
