#!/bin/sh

BUILDTYPE=Release
if [ $# -ne 0 ]; then
    if [ $1 = "Debug" ]; then
        BUILDTYPE=Debug
    fi
fi

CC=clang CXX=clang++ cmake ../ -GNinja -DCMAKE_BUILD_TYPE=$BUILDTYPE -DLLVM_BUILD_32_BITS=ON -DLLVM_BUILD_LLVM_DYLIB=ON -DLLVM_ENABLE_LIBEDIT=OFF -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_TARGETS_TO_BUILD="X86;ARM;AArch64" -DLLVM_BINUTILS_INCDIR=/usr/include/

