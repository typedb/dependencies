#!/bin/bash

set -e

# TODO: Remove once CircleCI fixes the issue with apt
function apt_wait() {
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
}

function install_dependencies() {
    echo "Installing rpmbuild..."
    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        apt_wait
        sudo apt-get update
        sudo apt-get install rpm
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        brew install rpm
    else
        echo "Your platform does not have rpmbuild executable for it. Make sure you are using Linux/macOS".
        exit 1
    fi
}

cd /opt/circleci/.pyenv/plugins/python-build/../.. && git pull && cd -
if [[ -n "$BAZEL_BUILDBUDDY_CERT" && -n "$BAZEL_BUILDBUDDY_KEY" ]]; then
    echo "Installing BuildBuddy credential..."
    BAZEL_BUILDBUDDY_CREDENTIAL=/opt/.credentials/
    echo "A BuildBuddy credential is found and will be saved to $BAZEL_BUILDBUDDY_CREDENTIAL. Targets will be built and tested remotely."
    sudo mkdir -p $BAZEL_BUILDBUDDY_CREDENTIAL && sudo chmod a+rwx $BAZEL_BUILDBUDDY_CREDENTIAL
    echo $BAZEL_BUILDBUDDY_CERT | base64 -d > "$BAZEL_BUILDBUDDY_CREDENTIAL/buildbuddy-cert.pem"
    echo $BAZEL_BUILDBUDDY_KEY | base64 -d > "$BAZEL_BUILDBUDDY_CREDENTIAL/buildbuddy-key.pem"
    echo "The RBE credential has been installed!"
    echo "Configuring Python..."
    # setting the exact version of Python 3 and Python 2, respectively
    pyenv install -s 3.6.10
    pyenv global 3.6.10 system
else
    echo "No RBE credential found. Bazel will be executed locally without RBE support."
    install_dependencies
    echo "Configuring Python..."
    # uses system version of python, according to the image that is set
    pyenv global system system
fi
