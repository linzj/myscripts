if [ $# != 1 ] ; then
  echo "need the pacakge name" 1>&2
  exit 1
fi

adb shell pm grant $1 android.permission.WRITE_EXTERNAL_STORAGE
adb shell pm grant $1 android.permission.READ_EXTERNAL_STORAGE
