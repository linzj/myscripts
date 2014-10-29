SYSDIR=./out/target/product/generic_x86/
LD_LIBRARY_PATH=/media/linzj/normal/home/linzj/src/androidsrc/android/prebuilts/tools/linux-x86/emulator/lib:$LD_LIBRARY_PATH \
emulator64-x86 -sysdir $SYSDIR -system $SYSDIR/system.img -ramdisk $SYSDIR/ramdisk.img -data out/target/product/generic/userdata.img -kernel prebuilts/qemu-kernel/x86/kernel-qemu -sdcard sdcard.img -skindir /home/linzj/android-sdks/platforms/android-18/skins -skin WVGA800 -scale 0.7 -memory 1800 -partition-size 1024  
