COMPILER_PREFIX=aarch64-linux-android-

export ARCH=arm64
export SUBARCH=arm64
export CROSS_COMPILE=${COMPILER_PREFIX}

cd tools
export PATH=/home/linzj/android-ndk-r13b/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64/bin:$PATH
#export CFLAGS="-O2 -g --sysroot=/home/linzj/android-ndk-r13b/platforms/android-21/arch-arm64"
export EXTRA_CFLAGS="-O2 -g --sysroot=/home/linzj/android-ndk-r13b/platforms/android-24/arch-arm64"
export WERROR=0
make V=1 CROSS_COMPILE=${COMPILER_PREFIX} -j9 perf

