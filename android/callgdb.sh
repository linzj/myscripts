cd src/out/Android_Debug/
mkdir -p rom-tmp/
rm rom-tmp/*
adb pull /system/lib/libc.so rom-tmp/libc.so
adb pull /system/bin/app_process32 rom-tmp/app_process32
mkdir -p so-tmp/
mv *.so so-tmp/
~/src/binutils-gdb/building/built/usr/local/bin/arm-linux-androideabi-gdb rom-tmp/app_process32  -ex 'set solib-search-path rom-tmp:lib.unstripped' -ex 'set sysroot /' -ex 'target remote :5039'
mv so-tmp/* .
