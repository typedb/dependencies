#!/usr/bin/env bash

set -e
BAZEL_VERSION=0.29.1

brew cask install homebrew/cask-versions/adoptopenjdk8
curl -OL https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh
chmod +x bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh
sudo ./bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh
rm ./bazel-${BAZEL_VERSION}-installer-darwin-x86_64.sh
