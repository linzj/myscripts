#!/bin/sh

BUILDTYPE=Release
if [ $# -ne 0 ]; then
    if [ $1 = "Debug" ]; then
        BUILDTYPE=Debug
    fi
fi

CC=clang CXX=clang++ cmake ../ -GNinja -DCMAKE_BUILD_TYPE=$BUILDTYPE -DLLVM_ENABLE_LIBEDIT=OFF -DLLVM_ENABLE_LIBXML2=OFF -DLLVM_ENABLE_TERMINFO=OFF -DLLVM_TARGETS_TO_BUILD="X86;ARM;AArch64" -DCMAKE_EXE_LINKER_FLAGS="-static-libgcc -static-libstdc++" -DCMAKE_SHARED_LINKER_FLAGS="-static-libgcc -static-libstdc++" -DLLVM_BINUTILS_INCDIR=/usr/include/
