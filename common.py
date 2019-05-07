import os
import subprocess as sp


def shell_execute(*args, **kwargs):
    with open(os.devnull, 'w') as devnull:
        try:
            output = sp.check_output(*args, stderr=sp.STDOUT, **kwargs)
            if type(output) == bytes:
                output = output.decode()
            return output
        except sp.CalledProcessError as e:
            print('An error occurred when running "' + str(e.cmd) + '". Process exited with code ' + str(
                e.returncode) + ' and message "' + e.output + '"')
            raise e
