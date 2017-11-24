#!/bin/sh

if ! [ -d gcc-trunk ] ; then
    echo "no gcc-trunk in current directory." 1>&2
    exit 1
fi

if ! [ -d binutils-gdb ] ; then
    echo "no binutils in current directory." 1>&2
    exit 1
fi

mkdir building
cd building
../binutils-gdb/symlink-tree ../binutils-gdb/ && ../binutils-gdb/symlink-tree ../gcc-trunk/
