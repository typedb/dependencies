#!/usr/bin/env bash

set -e
brew cask install homebrew/cask-versions/adoptopenjdk8
curl -OL https://github.com/bazelbuild/bazel/releases/download/0.26.1/bazel-0.26.1-installer-darwin-x86_64.sh
chmod +x bazel-0.26.1-installer-darwin-x86_64.sh
sudo ./bazel-0.26.1-installer-darwin-x86_64.sh
rm ./bazel-0.26.1-installer-darwin-x86_64.sh
