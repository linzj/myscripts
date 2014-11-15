export ARCH=x86
export SUBARCH=x86
export CROSS_COMPILE=i686-linux-android-
#export CROSS_COMPILE=x86_64-linux-android-
TARGET_ARCH=x86
#export PATH=/media/linzj/normal/home/linzj/src/androidsrc/android/prebuilts/gcc/linux-x86/x86/x86_64-linux-android-4.9/bin:$PATH

NDK_ROOT=`dirname $(which ndk-build)`
export ANDROID_NDK_ROOT=$NDK_ROOT

if [ -z "$ANDROID_TOOLCHAIN" ]; then
    if [ "$TARGET_ARCH" = "x86" ]; then
        TOOLCHAIN_PATH=`dirname $(find $NDK_ROOT/toolchains $NDK_ROOT/build  -name 'i686*' -name '*-g++' | sort  -r | head -n 1)`
    elif [ "$TARGET_ARCH" = "arm" ]; then
        TOOLCHAIN_PATH=`dirname $(find $NDK_ROOT/toolchains $NDK_ROOT/build  -name 'arm*' -name '*-g++' | sort  -r | head -n 1)`
    else
        echo "unsupported platform " "$TARGET_ARCH" 1>&2
        exit 1
    fi
    export ANDROID_TOOLCHAIN=${TOOLCHAIN_PATH%/bin}
fi
export PATH=$ANDROID_TOOLCHAIN/bin:$PATH
#../external/qemu/distrib/build-kernel.sh --arch=x86
