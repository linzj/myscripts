HWKIND=emulator
NDK_PATH=/home/linzj/android-ndk-r8e
NDK_TOOLCHAINS=$NDK_PATH/toolchains/x86-4.9/prebuilt/linux-x86_64/bin
export PATH=$NDK_TOOLCHAINS:$PATH

CC=i686-linux-android-gcc \
CXX=i686-linux-android-g++ \
AR=i686-linux-android-ar \
LD=i686-linux-android-ld \
CPP=i686-linux-android-cpp \
RANLIB=i686-linux-android-ranlib \
CFLAGS="-O2 --sysroot=$NDK_PATH/platforms/android-14/arch-x86 -I$NDK_PATH/platforms/android-14/arch-x86/usr/include -fno-pic" \
CPPFLAGS="--sysroot=$NDK_PATH/platforms/android-14/arch-x86 -I$NDK_PATH/platforms/android-14/arch-x86/usr/include -DANDROID_HARDWARE_$HWKIND" \
LDFLAGS="--sysroot=$NDK_PATH/platforms/android-14/arch-x86" \
./configure --host=i686-linux-androideabi --target=i686-android-linux  \
   --with-tmpdir=/sdcard --prefix=/data/local/tmp/tools/

if [ $? == 0 ]
then
    make -j9
fi
