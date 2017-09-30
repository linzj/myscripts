SCRIPTDIR=`dirname $0`
STATIC_LIBS=`readlink -f ${SCRIPTDIR}/static_libs`
echo $STATIC_LIBS

cplib () {
    for lib in $@; do
        LIBLOCATION=`locate $lib`
        cp $LIBLOCATION $STATIC_LIBS/
        if test $? -ne 0; then
            echo cp $lib failed
            rm -rf $STATIC_LIBS
            exit 1
        fi
    done
}

build_static_libs () {
    mkdir $STATIC_LIBS
    cplib libgmp.a  libisl.a  libmpc.a  libmpfr.a
}

if [ -e $STATIC_LIBS ]; then
    if ! [ -d $STATIC_LIBS ]; then
        rm -f $STATIC_LIBS
        build_static_libs
    fi
else
    build_static_libs
fi
export CFLAGS=-fPIC

$1 --prefix=`pwd`/built --target=arm-linux-androideabi --with-gnu-as  --enable-languages=c,c++ --disable-libssp --disable-nls --disable-libitm --disable-libmudflap --enable-plugins --enable-libgomp --enable-graphite=yes --enable-libstdc__-v3 --disable-sjlj-exceptions --disable-tls --enable-gold --with-float=soft --with-fpu=vfp --with-arch=armv5te --enable-target-optspace --enable-initfini-array --disable-nls --with-sysroot=/home/linzj/android-ndk-r10e/platforms/android-21/arch-arm --with-arch=armv5te --program-transform-name='s,^,arm-linux-androideabi-,' --enable-shared=libsanitizer --with-gmp-lib=$STATIC_LIBS --with-mpc-lib=$STATIC_LIBS --with-mpfr-lib=$STATIC_LIBS --with-isl-lib=$STATIC_LIBS
