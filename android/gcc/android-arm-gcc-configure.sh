export CFLAGS="-fPIC -O2 -g"
#export CXXFLAGS=-fPIC
# setup target tools

NDK_ROOT=`dirname $(which ndk-build)`
if [ -z $NDK_ROOT ]; then
  echo failed to detect ndk root
  exit 1
fi
if [ -z $SYSROOT ]; then
  SYSROOT=$NDK_ROOT/platforms/android-21/arch-arm
fi
TARGET_ARCH=armeabi
export ANDROID_NDK_ROOT=$NDK_ROOT

# If not defined ANDROID_TOOLCHAIN, it search the ndk directory and find the gcc-4.4.3 to compile v8.
if [ -z "$ANDROID_TOOLCHAIN" ]; then
    if [ "$TARGET_ARCH" = "x86" ]; then
        TOOLCHAIN_PATH=`dirname $(find $NDK_ROOT/toolchains $NDK_ROOT/build  -name 'i686*' -name '*-g++' | sort | head -n 1)`
    elif [ "$TARGET_ARCH" = "armeabi" ]; then
        TOOLCHAIN_PATH=`dirname $(find $NDK_ROOT/toolchains $NDK_ROOT/build  -name 'arm*' -name '*-g++' | sort | head -n 1)`
        EXTRA_OPTION="armv7=false vfp2=off vfp3=off"
    elif [ "$TARGET_ARCH" = "armeabi-v7a" ]; then
        TOOLCHAIN_PATH=`dirname $(find $NDK_ROOT/toolchains $NDK_ROOT/build  -name 'arm*' -name '*-g++' | sort | head -n 1)`
        EXTRA_OPTION="armv7=true vfp2=on vfp3=on"
    else
        echo "unsupported platform " "$TARGET_ARCH" 1>&2
        exit 1
    fi
    export ANDROID_TOOLCHAIN=${TOOLCHAIN_PATH%/bin}
fi

export AR_FOR_TARGET=$ANDROID_TOOLCHAIN/arm-linux-androideabi/bin/ar
export AS_FOR_TARGET=$ANDROID_TOOLCHAIN/arm-linux-androideabi/bin/as
export LD_FOR_TARGET=$ANDROID_TOOLCHAIN/arm-linux-androideabi/bin/ld.bfd
export NM_FOR_TARGET=$ANDROID_TOOLCHAIN/arm-linux-androideabi/bin/nm
export OBJCOPY_FOR_TARGET=$ANDROID_TOOLCHAIN/arm-linux-androideabi/bin/objcopy
export OBJDUMP_FOR_TARGET=$ANDROID_TOOLCHAIN/arm-linux-androideabi/bin/objdump
export RANLIB_FOR_TARGET=$ANDROID_TOOLCHAIN/arm-linux-androideabi/bin/ranlib
export READELF_FOR_TARGET=$ANDROID_TOOLCHAIN/arm-linux-androideabi/bin/readelf

$1 --target=arm-linux-androideabi --with-gnu-as  --enable-languages=c,c++ --disable-libssp --disable-nls --disable-libitm --disable-libmudflap --enable-plugins --enable-libgomp --enable-graphite=yes --enable-libstdc__-v3 --disable-sjlj-exceptions --disable-tls --enable-gold --with-float=soft --with-fpu=vfp --with-arch=armv5te --enable-target-optspace --enable-initfini-array --disable-nls --with-sysroot=$SYSROOT --with-arch=armv5te --program-transform-name='s,^,arm-linux-androideabi-,' --enable-shared=libsanitizer --with-mpc=/home/linzj/src/build-gcc/static_libs --with-mpfr=/home/linzj/src/build-gcc/static_libs --with-gmp=/home/linzj/src/build-gcc/static_libs --with-isl=/home/linzj/src/build-gcc/static_libs
