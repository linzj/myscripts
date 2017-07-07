set PYTHONPATH="d:\v8\v8\tools\generate_shim_headers;d:\v8\v8\gypfiles;d:\v8\v8\tools\gyp\pylib:" 
set PATH=C:\Python27;D:\v8\depot_tools;%PATH%

set GYP_GENERATORS=ninja
tools\gyp\gyp.bat gypfiles/all.gyp  -Igypfiles/standalone.gypi --depth=.  -Dv8_target_arch=x64  -Dtarget_arch=x64 -S.x64.debug  -Dclang=0 -Dv8_enable_backtrace=1 -Darm_fpu=default -Darm_float_abi=default

ninja -C out\Debug_x64
