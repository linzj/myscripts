#!/bin/sh

if [ -d gcc-trunk ] then;
    echo "no gcc-trunk in current directory." 1>&2
fi

if [ -d binutils-gdb ] then;
    echo "no gcc-trunk in current directory." 1>&2
fi

mkdir building
cd building
../gcc-trunk/symlink-tree ../binutils-gdb/ && ../gcc-trunk/symlink-tree ../gcc-trunk/
