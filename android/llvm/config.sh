# Use the build standalone toolchian to get the toolchain first.
ANDROID_TOOLCHAIN=/home/linzj/src/llvm/building/build-rtx86/android-toolchain
ANDROID_BUILD_DIR=.
LLVM_CHECKOUT=../../
BUILD_TYPE=Release

# Always clobber android build tree.
# It has a hidden dependency on clang (through CXX) which is not known to
# the build system.
mkdir $ANDROID_BUILD_DIR
(cd $ANDROID_BUILD_DIR && \
 cmake -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
 -DLLVM_ANDROID_TOOLCHAIN_DIR=$ANDROID_TOOLCHAIN \
 -DCMAKE_TOOLCHAIN_FILE=$LLVM_CHECKOUT/cmake/platforms/Android_x86.cmake \
 $LLVM_CHECKOUT)
