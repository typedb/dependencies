# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at https://mozilla.org/MPL/2.0/.


import os
import subprocess as sp
import tempfile


def shell_execute(args, **kwargs):
    with tempfile.NamedTemporaryFile(delete=True) as tmpstdout, \
            tempfile.NamedTemporaryFile(delete=True) as tmpstderr:

        process = sp.Popen(args, stdout=tmpstdout, stderr=tmpstderr, **kwargs)
        process.wait()

        tmpstdout.seek(0)
        out = tmpstdout.read()
        if type(out) == bytes:
            out = out.decode()

        tmpstderr.seek(0)
        err = tmpstderr.read()
        if type(err) == bytes:
            err = err.decode()

        if process.returncode == 0:
            return out, err
        else:
            raise RuntimeError('An error occurred.\n' +
                               '- Command = "' + str(args) + '"\n' +
                               '- Exit code = "' + str(process.returncode) + '"\n' +
                               '- Working directory = "' + str(os.getcwd()) + '"\n' +
                               '- stdout = "' + out + '"\n' +
                               '- stderr = "' + err + '"\n')
