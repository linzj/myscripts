COMPILER_PREFIX=arm-linux-androideabi-
function doConfig() {
DEFCONFIG_FILE=flo_defconfig

if [ ! -e arch/arm/configs/$DEFCONFIG_FILE ]; then
	echo "No such file : arch/arm/configs/$DEFCONFIG_FILE"
	exit -1
fi

# make .config
env KCONFIG_NOTIMESTAMP=true \
make ARCH=arm CROSS_COMPILE=${COMPILER_PREFIX} ${DEFCONFIG_FILE}

# run menuconfig
env KCONFIG_NOTIMESTAMP=true \
make menuconfig ARCH=arm

make savedefconfig ARCH=arm
# copy .config to defconfig
mv defconfig arch/arm/configs/${DEFCONFIG_FILE}
# clean kernel object
#make mrproper
}

if [ $1 = "DOCONFIG" ]; then
    doConfig
    exit $?
fi

export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE=arm-linux-androideabi-

make CROSS_COMPILE=${COMPILER_PREFIX} -j9

