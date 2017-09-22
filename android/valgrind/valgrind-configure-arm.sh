NDK_PATH=/home/linzj/android-ndk-r10e
NDK_TOOLCHAINS=$NDK_PATH/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin
export PATH=$NDK_TOOLCHAINS:$PATH

CC=arm-linux-androideabi-gcc \
CPP=arm-linux-androideabi-cpp \
CXX=arm-linux-androideabi-g++ \
AR=arm-linux-androideabi-ar \
LD=arm-linux-androideabi-ld \
RANLIB=arm-linux-androideabi-ranlib \
CFLAGS="-O2 --sysroot=$NDK_PATH/platforms/android-14/arch-arm -I$NDK_PATH/platforms/android-14/arch-arm/usr/include" \
CPPFLAGS="--sysroot=$NDK_PATH/platforms/android-14/arch-arm -I$NDK_PATH/platforms/android-14/arch-arm/usr/include" \
LDFLAGS="--sysroot=$NDK_PATH/platforms/android-14/arch-arm" \
./configure --host=armv7-linux-androideabi --target=armv7-android-linux \
   --with-tmpdir=/data/local/tmp --prefix=/data/local
if [ $? == 0 ]
then
    make -j9
fi

