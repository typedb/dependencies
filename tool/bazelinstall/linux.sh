#!/usr/bin/env bash

set -e
BAZEL_VERSION=3.2.0

curl -OL https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
chmod +x bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
sudo ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
rm ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
