import os
import subprocess as sp


def shell_execute(*args):
    p = sp.Popen(args, stdout=sp.PIPE, stderr=sp.PIPE)
    p.wait()
    out = p.stdout.read()
    err = p.stderr.read()
    if p.returncode == 0:
        if type(out) == bytes:
            out = out.decode()
        if type(err) == bytes:
            err = err.decode()
        return out, err
    else:
        raise RuntimeError('An error occurred when running "' + str(' '.join(args)) + '"\n' +
                           'Exit code = "' + str(p.returncode) + '"\n' +
                           'stdout = "' + out + '"\n' +
                           'stderr = "' + err + '"\n')
