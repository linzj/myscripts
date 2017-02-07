PACKAGE_NAME=com.UCMobile
if [ $# -gt 0 ]
then
PACKAGE_NAME=$1
fi

MYASS=`adb shell ps | tr "\r\n" "\n" | grep -Pwm1 "$PACKAGE_NAME"'$' | awk '{print $2}'`
T1=`adb shell su -c "'cat /proc/$MYASS/stat'" | awk 'BEGIN {OFS="-";} {print $14,$15}'`
sleep 10
T2=`adb shell su -c "'cat /proc/$MYASS/stat'" | awk 'BEGIN {OFS="-";} {print $14,$15}'`
echo $T1
echo $T2
echo "$T1-$T2" | awk 'BEGIN {FS="-"; t1=0;t2=0;} { t1 = $3-$1; t2=$4-$2; } END { print t1,t2; }'
