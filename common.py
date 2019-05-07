import os
import subprocess as sp
import tempfile


def shell_execute(args, **kwargs):
    with tempfile.NamedTemporaryFile(delete = True) as tmpstdout, \
            tempfile.NamedTemporaryFile(delete = True) as tmpstderr:

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
            print('cmd = {}\nout = {}\nerr = {}'.format(args, out, err))
            return out, err
        else:
            raise RuntimeError('An error occurred.\n' +
                               '- Command = "'+ str(args) + '"\n' +
                               '- Exit code = "' + str(process.returncode) + '"\n' +
                               '- Working directory = "' + str(cwd) + '"\n' +
                               '- stdout = "' + out + '"\n' +
                               '- stderr = "' + err + '"\n')
