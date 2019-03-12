PROCESS_NAME=com.UCMobile
if [ $# -gt 0 ]
then
PROCESS_NAME=$1
fi
IFS=':' read -r -a array <<< $PROCESS_NAME
PACKAGE_NAME=${array[0]}

MYASS=`adb shell ps | tr "\r\n" "\n" | grep -Pwm1 "$PROCESS_NAME"'$' | awk '{print $2}'`
if [ -z $MYASS ]; then
  MYASS=`adb shell ps -A | tr "\r\n" "\n" | grep -Pwm1 "$PROCESS_NAME"'$' | awk '{print $2}'`
fi

if [ -z $MYASS ]; then
  MYASS=$2
fi
echo $MYASS
DEBUG_SOCKET=debug-socket
DEBUG_PORT=5039
DATA_DIR=/data/data/$PACKAGE_NAME
adb forward tcp:$DEBUG_PORT localfilesystem:$DATA_DIR/$DEBUG_SOCKET
adb push ~/android-ndk-r10e/prebuilt/android-arm/gdbserver/gdbserver /data/local/tmp/
adb shell run-as $PACKAGE_NAME cp /data/local/tmp/gdbserver /data/data/$PACKAGE_NAME/gdbserver
adb shell run-as $PACKAGE_NAME chmod 755 /data/data/$PACKAGE_NAME/gdbserver
adb shell run-as $PACKAGE_NAME /data/data/$PACKAGE_NAME/gdbserver +$DEBUG_SOCKET  --attach $MYASS

