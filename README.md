Samantaz's scripts
==================

Some useful scripts I use on a more-or-less daily basis.


About scripts.d
----------------

The `scripts.d` directory contains multiple files, each defining one (or more)
shell functions. In order to load these functions in the user's environment,
add the following code snippet to the user's `.bashrc`:

```
# Source the different functions contained in scripts.d
# Update $SCRIPTS_DIR according to the path where the scripts.d folder is.
#
SCRIPTS_DIR=~/scripts.d

for fn in `ls $SCRIPTS_DIR/scripts.d/`; do
	. $SCRIPTS_DIR/scripts.d/$fn
done

unset SCRIPTS_DIR
```

Warning: These scripts have only been tested on `bash`. It is not guaranteed
that they'll be compatible with `zsh` or any other shell.
