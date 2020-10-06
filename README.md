Samantaz's scripts
==================

Some useful scripts I use on a more-or-less daily basis.


Warning
-------

These scripts have been tested on `bash` and `zsh`. There is no guarantee that
they will be compatible other shells. I'm trying my best, thought, and
contributions are welcome!

As a friendly reminder: never run shell scripts without knowing what they do,
particularly when you're root! I encourage you to look at them and to try to
understand what's going on under the hood. I do my best at properly commenting
the code :)


Requirements
------------

All the scripts in this repository are created assuming that the machine has
the following GNU tools installed:
 * coreutils
 * sed

Other requirements:
 * the `sudo` utility
 * GNU `wget`
 * `scripts.d/apk-extract` requires `unzip`
 * `scripts.d/clipboard-convert` requires `gzip`, `xclip` and [barrier](https://github.com/debauchee/barrier)
 * `scripts.d/compress-mp4` requires `ffmpeg`
 * `scripts.d/exif` requires ImageMagick's `mogrify` and Lutz Mueller's `exif`
 * `scripts.d/gpg-keys-sizes` requires `gpg` and `awk`
 * `scripts.d/mount-iso` requires `fuseiso` (unless run as root)
 * `scripts.d/fingerprints` requires OpenSSH's `ssh-keygen`
 * `scripts.d/yt-*` requires `youtube-dl`


About scripts.d
----------------

The `scripts.d` directory contains multiple files, each defining one (or more)
shell functions. In order to load these functions in the user's environment,
add the following code snippet to the user's `.bashrc`:

```
# Source the different functions contained in scripts.d
# Update $SCRIPTS_DIR according to the path where the scripts.d folder is.
#
SCRIPTS_DIR=~/.local/bin/scripts.d

for fn in `ls $SCRIPTS_DIR/scripts.d/`; do
	. $SCRIPTS_DIR/scripts.d/$fn
done

unset SCRIPTS_DIR
```


License
-------

This repo's content is released under the BSD 3-clauses licenses.

Read the [LICENSE](LICENSE.md) file for more infos.
