#!/usr/bin/env bash
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

in=$1
out=$(pwd)/$2
files_to_keep=$3

dest=$(mktemp -d)

if [[ "$(file --dereference --mime-type --brief $in)" == "application/zip" ]]; then
   unzip -d "$dest" "$in" &>/dev/null
else
   tar -xzf "$in" -C "$dest" &>/dev/null
fi

f=("$dest"/*)
mv "$dest"/*/* "$dest"
rmdir "${f[@]}"
cd $dest || exit 1

ls -1 | grep -v -E "$files_to_keep" | xargs rm -rf
tar -czf $out .
rm -rf $dest
