Debugging `patchelf` on `manylinux`
==================================

This repository is just a testing repo so we can try and straighten out the [`patchelf` issues reported here](https://github.com/NixOS/patchelf/issues/10). The `Dockerfile` held within will allow you to spin up a testing environment that builds a debuggable `binutils`, @staticfloat's patched `patchelf`, and copies in some example libraries from the linked issue.  To use, run something akin to:

```
$ ./get-deps.sh
$ docker build -t patchelf_test .
$ docker run -ti patchelf_test /bin/bash
```

This will put you into a workspace that has libraries placed in the current working directory in a similar manner as described by @ogrisel, then run `./do_patchelf_dance.sh` to run `patchelf` and then `strip` on the binaries, to make sure that everything works.

If something doesn't work, and you want to debug it, `gdb` and a debuggable `strip` are installed, just run `gdb --args /usr/local/bin/strip -vS ./foo.so` to debug and step through the `strip` binary.
