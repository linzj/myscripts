HWKIND=emulator

CC=i686-linux-android-gcc \
CXX=i686-linux-android-g++ \
AR=i686-linux-android-ar \
LD=i686-linux-android-ld \
CFLAGS="-fno-pic" \
CPPFLAGS="-DANDROID_HARDWARE_$HWKIND" \
../configure --host=i686-linux-androideabi --target=i686-android-linux \
   --with-tmpdir=/sdcard
#./configure --host=armv7-linux-android --target=armv7-android-linux --with-tmpdir=/sdcard --prefix=/data/local/tmp/tools
