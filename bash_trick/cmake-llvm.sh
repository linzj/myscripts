CC=clang CXX=clang++ cmake ../ -DCMAKE_BUILD_TYPE=Release -DLLVM_TARGETS_TO_BUILD="X86;ARM;AArch64" -DLLVM_BINUTILS_INCDIR=/usr/include/