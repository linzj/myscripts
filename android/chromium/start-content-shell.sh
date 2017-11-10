adb shell am start \
  -a android.intent.action.VIEW \
  -n org.chromium.content_shell_apk/.ContentShellActivity \
  'http://3g.163.com'

#  --esa commandLineArgs --js-flags='"--expose-gc --prof --logfile=/data/data/org.chromium.content_shell_apk/shit-%p"'\
