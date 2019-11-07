NDK_PATH=/home/linzj/android-ndk-r13b
NDK_TOOLCHAINS=$NDK_PATH/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64

CC=clang \
CXX=clang++ \
AR=llvm-ar \
RANLIB=llvm-ranlib \
CFLAGS="-target armv7-linux-android -O2 --sysroot=$NDK_PATH/platforms/android-21/arch-arm -I$NDK_PATH/platforms/android-21/arch-arm/usr/include --gcc-toolchain=$NDK_TOOLCHAINS" \
CPPFLAGS="-target armv7-linux-android --sysroot=$NDK_PATH/platforms/android-21/arch-arm -I$NDK_PATH/platforms/android-21/arch-arm/usr/include  -isystem $NDK_PATH/sources/cxx-stl/llvm-libc++/include" \
CXXFLAGS="-target armv7-linux-android --sysroot=$NDK_PATH/platforms/android-21/arch-arm -I$NDK_PATH/platforms/android-21/arch-arm/usr/include  -isystem $NDK_PATH/sources/cxx-stl/llvm-libc++/include" \
LDFLAGS="-pie -fuse-ld=lld -static-libstdc++ --sysroot=$NDK_PATH/platforms/android-21/arch-arm --gcc-toolchain=$NDK_TOOLCHAINS -L$NDK_PATH/sources/cxx-stl/llvm-libc++/libs/armeabi-v7a/" \
../gdb/gdbserver/configure --host=armv7-linux-androideabi --target=armv7-android-linux \
   --with-tmpdir=/data/local/tmp --prefix=/data/local
if [ $? == 0 ]
then
    make -j9
fi


