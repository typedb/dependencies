#!/usr/bin/env bash
#
# Copyright (C) 2022 Vaticle
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#

git="git -C $BUILD_WORKSPACE_DIRECTORY"

if $git diff --exit-code HEAD^ HEAD -- LATEST_RELEASE_NOTES.md; then
    echo "validate_release_notes.sh failed!"
    echo
    echo -n "The script has detected changes in the repository since the last time the release notes had been updated. "
    echo "Please make sure those changes are reflected in the LATEST_RELEASE_NOTES.md."
    echo
    echo "LATEST_RELEASE_NOTES.md was last updated on $($git log -n 1 --pretty='%aD, commit SHA %h' -- LATEST_RELEASE_NOTES.md)"
    echo
    echo "Since then, the following commits have been added:"
    $git log $($git log -n 1 --pretty='%H' -- LATEST_RELEASE_NOTES.md)..HEAD --oneline --decorate=no |
        awk '{ buf[i++] = $0; } END { while (i--) { print buf[i]; } }'  # reverse git log output
    echo
    echo "Aborting release."
    exit 1
else
    exit 0
fi
