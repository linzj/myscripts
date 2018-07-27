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
~/android-sdks/platform-tools/adb shell run-as $PACKAGE_NAME /data/data/$PACKAGE_NAME/lib/gdbserver +$DEBUG_SOCKET  --attach $MYASS
