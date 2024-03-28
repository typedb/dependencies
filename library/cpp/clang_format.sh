# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.

differing_count=0
for f in "${@:2}";do
  echo "- Checking $f"
  clang-format -style=file:$1 $f | diff $f -  ;
  let differing_count+=$?
  echo "================================================================================"
done
echo "Differing files: $differing_count"

exit_code=0
if [ $differing_count -gt 0 ]; then exit_code=1; fi
exit $exit_code
