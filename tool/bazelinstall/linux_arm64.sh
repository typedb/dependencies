#!/usr/bin/env bash

set -e

BAZEL_VERSION_FILE=.bazelversion
if [ ! -e $BAZEL_VERSION_FILE ]
then
  echo "Could not find the '$BAZEL_VERSION_FILE' file"
  exit 1
fi
BAZEL_VERSION=$(cat $BAZEL_VERSION_FILE)

curl -OL https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-arm64.sh
chmod +x bazel-${BAZEL_VERSION}-installer-linux-arm64.sh
sudo ./bazel-${BAZEL_VERSION}-installer-linux-arm64.sh
rm ./bazel-${BAZEL_VERSION}-installer-linux-arm64.sh
