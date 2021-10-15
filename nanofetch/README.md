# nanofetch

Yes, I know, there are already dozen of similar tools available on interet, so
you may (understandably) ask "why another one?".

The problem I had with all previous tools like `screenfetch` or `neofetch` is
that they are freaking _slow_! `screenfetch` takes up to a **whole second** to
load!

In addition to that, they have way too many infos displayed by default, their
logos are way too large (they take too many terminal lines)

<br/>

Want to see how it looks? Check https://samantaz.fr/projects/nanofetch.html !


## Goals

`nanofetch` tries to stay within the following constrains:

* Runs in less than 100ms
* Takes as minimal terminal space as possible (8 lines / < 80 columns)
* Provides as much relevant information as it can in this space
* Provide nice ASCII art visuals
* Run on as many systems as possible

These five rules are very challenging, especially the interoperability and
performance ones, which sometimes require tricky shell magic.


## Displayed data

`nanofetch` displays the following system informations:

* OS: either OS (BSD/windows) or distro (Linux) name and version
* Kernel: architecture, kernel name and version
* Shell: name and version
* Disks: used, total and free disk space (local storage only)
* CPU: vendor, commercial name, core/threads count and frequency
* GPU: vendor, commercial name and architecture or chip name
* RAM: used, total available and free memory


## Support list

### Shells tested and entirely supported

- Bourne again shell (`bash`)
- The Z shell (`zsh`)
- Korn shell (`ksh`)
- C shell (`csh` / `tcsh`)
- `dash`
- POSIX `sh`

### CPU architectures

| Arch   | Comment |
| ------ | ------- |
| x86    | OK, multiple AMD and Intel processors tested |
| x86_64 | ditto |
| ARM    | Mostly OK, could be a problem on systems with 2 different CPUs (mobile) |
| Others | Not tested, but most of them should work, unless exotic software |

### OSes/Distros

**Linux:**

| Name        | Comment |
| ----------- | --------|
| Archlinux   | OK |
| Debian      | Not entirely sure, not tests done in a while |
| Fedora      | OK (Thanks to Katie & Wolf for testing this) |
| Ubuntu      | OK |

**BSD:**

| Name      | Comment |
| --------- | --------|
| FreeBSD   | almost complete. GPU not working |
| NetBSD    | Not tested |
| OpenBSD   | partial. GPU and disks not working |

**Windows:**

Same thing for Cygwin, Git for windows (mingw) and MSYS2:
* I haven't found how/where to get the GPU infos
* CPU core count is incorrect
* Everything else (kernel, disks, RAM, CPU) works OK

**Others:**

All other systems (MacOS, SunOS/Solaris/Illumos, other BSDs) have not been
tested, so chances are high that they won't work.
