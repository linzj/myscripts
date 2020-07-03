NDK_PATH=/home/linzj/android-ndk-r13b
NDK_TOOLCHAINS=$NDK_PATH/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

CC=clang \
CXX=clang++ \
AR=llvm-ar \
RANLIB=llvm-ranlib \
CFLAGS="-target aarch64-linux-android -O2 --sysroot=$NDK_PATH/platforms/android-21/arch-arm64 -I$NDK_PATH/platforms/android-21/arch-arm64/usr/include --gcc-toolchain=$NDK_TOOLCHAINS" \
CPPFLAGS="-target aarch64-linux-android --sysroot=$NDK_PATH/platforms/android-21/arch-arm64 -I$NDK_PATH/platforms/android-21/arch-arm64/usr/include  -isystem $NDK_PATH/sources/cxx-stl/llvm-libc++/include" \
CXXFLAGS="-target aarch64-linux-android --sysroot=$NDK_PATH/platforms/android-21/arch-arm64 -I$NDK_PATH/platforms/android-21/arch-arm64/usr/include  -isystem $NDK_PATH/sources/cxx-stl/llvm-libc++/include" \
LDFLAGS="-pie -fuse-ld=lld -static-libstdc++ --sysroot=$NDK_PATH/platforms/android-21/arch-arm64 --gcc-toolchain=$NDK_TOOLCHAINS -L$NDK_PATH/sources/cxx-stl/llvm-libc++/libs/arm64-v8a/" \
../gdb/gdbserver/configure --host=aarch64-linux-android --target=aarch64-android-linux \
   --with-tmpdir=/data/local/tmp --prefix=/data/local
if [ $? == 0 ]
then
    make -j9
fi
