#!/bin/sh
mkdir -p out/Android

cat >out/Android/args.gn <<EOF
# Build arguments go here. Examples:
#   is_component_build = true
#   is_debug = false
# See "gn args <out_dir> --list" for available build arguments.
target_os = "android"
target_cpu = "arm"  # (default)
is_debug = true  # (default)

# Other args you may want to set:
use_jumbo_build = true
is_component_build = true
is_clang = true
symbol_level = 2  # Faster build with fewer symbols. -g1 rather than -g2
enable_incremental_javac = true  # Much faster; experimental
EOF

gn args out/Android
gn gen out/Android && \
ninja -C out/Android webview_instrumentation_apk && \
adb install -r out/Android/apks/WebViewInstrumentation.apk

ninja -C out/Android_Release content_shell_apk && \
adb install -r out/Android_Release/apks/ContentShell.apk
