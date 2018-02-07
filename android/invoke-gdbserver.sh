#!/bin/sh
PACKAGE_NAME='com\.UCMobile'
if [ $# -gt 0 ]
then
PACKAGE_NAME=$1
fi

MYASS=`adb shell ps | tr "\r\n" "\n" | grep -Pwm1 "$PACKAGE_NAME"'$' | awk '{print $2}'`
echo $MYASS
adb forward tcp:5039 tcp:5039
#adb shell su -c //data/local/tmp/gdbserver :5039 --attach $MYASS
#adb shell su -c "//data/local/tmp/gdbserver :5039 --attach $MYASS"
adb shell su -c "'/data/local/tmp/gdbserver :5039 --attach $MYASS'"
