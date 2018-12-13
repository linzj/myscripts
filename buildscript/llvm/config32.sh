#!/bin/sh

BUILDTYPE=Release
if [ $# -ne 0 ]; then
    if [ $1 = "Debug" ]; then
        BUILDTYPE=Debug
    fi
fi

CC=clang CXX=clang++ cmake ../ -DCMAKE_BUILD_TYPE=$BUILDTYPE -DLLVM_BUILD_32_BITS=ON -DLLVM_TARGETS_TO_BUILD="X86;ARM;AArch64" -DLLVM_BINUTILS_INCDIR=/usr/include/

