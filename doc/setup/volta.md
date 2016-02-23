---
title: Getting started with Volta
layout: page
---

# Dependencies #

As Volta is written in D, a compiler for D is needed. GDC, LDC and DMD should
be able to compile Volt. Once Volt is capable enough the compiler will be
ported to Volt and become self-hosting.

Volt uses LLVM as a backend to generate binary code. Version 3.6.x is the least
supported version. Version 3.7.x has not been tested and it looks like changes
to the C interface are incompatible with the current binding to LLVM.


## Linux ##

Building Volt requires a D compiler as well as llvm:

    # Ubuntu / Debian
    $ sudo apt-get install dmd llvm

    # Arch Linux
    $ sudo pacman -S dmd llvm


Instead of using the packaged DMD binaries on Ubuntu or Debian you can use the
[D-APT](http://d-apt.sourceforge.net/) repository to install DMD.
Alternativly you can also use the
[official binaries](http://dlang.org/download.html).


## Mac ##

There are no packages of GDC for Mac so DMD should be used. To install it,
the easiest way is using [Homebrew](http://brew.sh). If you don't have it,
install it from [here](http://brew.sh)

Then, in a terminal

    brew install dmd

If you prefer not to use Homebrew, then download DMD from
[here](http://dlang.org/download.html), then just extract the contents of
dmd.2.<version>.zip <somewhere> and set the DMD environmental variable to be
"<somewhere>/osx/bin/dmd" or put the folder "<somewhere>/osx/bin" on the path.

For LLVM version 3.6, you can `brew install homebrew/versions/llvm36`,
then add `/usr/local/Cellar/llvm36/3.6.2/lib/llvm-3.6/bin` on your $PATH
(you may remove it afterwards). The reason for doing so is, that Homebrew
doesn't properly link non-core-only versions - like LLVM v3.6 if it comes from
`homebrew/versions/llvm36`. For example, `llvm-config` won't be
callable, but only `llvm-config-3.6`.

Without Homebrew, just download LLVM from the LLVM homepage, and put the bin
folder inside the unpacked tarball on the PATH, the builds system needs
`llvm-config` and the compiler requires some helpers from there to link.

Volt also requires the Boehm GC

    brew install bdw-gc

Or, without Homebrew

    curl http://www.hboehm.info/gc/gc_source/gc-7.4.2.tar.gz -o gc-7.4.2.tar.gz
    tar xfv gc-7.4.2.tar.gz
    cd gc-7.4.2
    git clone git://github.com/ivmai/libatomic_ops.git
    ./configure
    make

Then, copy `libgc.la` and `libcord.la` to the `rt` folder.


## Windows ##

The only compiler that has been used to compile Volta on Windows is DMD. Install
DMD and MinGW. You'll want a 32 bit MinGW that outputs DWARF exception
information.

Using MinGW's bash prompt, compile LLVM -- be sure to use
--enable-shared and build a DLL.

Once compiled, put the LLVM tools and DLL in your PATH, in with the D tools is
probably the simplest place. Run `implib /p:128 LLVM.lib <thellvmdll>` and place
that in the Volta directory. Run make (Digital Mars or GNU make should work) and
 with a bit of luck, you should have a working volt.exe.

You'll need to link with the [BoehmGC](http://www.hboehm.info/gc/). The MinGW
you compiled LLVM should suffice.

These directions need to be expanded, but hopefully this has pointed you in the
right direction.


## Other ##

For other platforms you need probably need to compile it you can get the latest
version from [here](https://bitbucket.org/goshawk/gdc/wiki/Home) Cross compiling
on Linux to Windows is confirmed working.


# Building #

Now you just need to build the compiler, to do so type:

    $ make
    # Super basic sanity test, with debug printing.
    $ make run

If the latter exits with Error 42, you're all set up !


# Compiling #

After running `make` you have a ready to use Volt compiler! You usually want to
link with the runtime and [Watt](https://github.com/VoltLang/Watt/). Volt has
a special configuration file which you can use for compiler options you always
want to include

    --stdlib-file
    %@execdir%/rt/libvrt-%@arch%-%@platform%.bc
    --stdlib-I
    %@execdir%/rt/src
    --stdlib-fi le
    %@execdir%/../Watt/libwatt-%@arch%-%@platform%.bc
    --stdlib-I
    %@execdir%/../Watt/src
    -L
    %@execdir%/rt
    -l
    gc
    -l
    dl

You need to place this file as `volt.conf` next to the Volt binary.
Every line represents one argument passed via commandline. `%@execdir%` gets
replaced with the path to the Volt binary, `%@arch%` with the current
architecture and `%@platform` with the current platform.

After setting everything up you can test the compiler

    $ ./volt test/test.volt
