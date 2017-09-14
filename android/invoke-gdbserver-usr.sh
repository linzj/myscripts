PACKAGE_NAME=com.UCMobile
if [ $# -gt 0 ]
then
PACKAGE_NAME=$1
fi

MYASS=`adb shell ps | tr "\r\n" "\n" | grep -Pwm1 "$PACKAGE_NAME"'$' | awk '{print $2}'`
echo $MYASS
DEBUG_SOCKET=debug-socket
DEBUG_PORT=5039
DATA_DIR=/data/data/$PACKAGE_NAME
adb forward tcp:$DEBUG_PORT localfilesystem:$DATA_DIR/$DEBUG_SOCKET
~/android-sdks/platform-tools/adb shell run-as $PACKAGE_NAME /data/data/$PACKAGE_NAME/lib/gdbserver +$DEBUG_SOCKET  --attach $MYASS
