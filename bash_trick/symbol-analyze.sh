#!/bin/bash
PREFIX=arm-linux-androideabi-
SYMFILE=
declare -a ACC

echoerr()
{
    echo $* 1>&2
}

setup_option()
{
    while getopts a: name    
        do
            case $name in
            a)
                case $OPTARG in
                x86)
                    PREFIX=
                    echoerr 'x86 setup';;
                arm)
                    echoerr 'arm setup';;
                *)
                    echoerr '-a should choose between x86 and arm'
                    exit 1
                    ;;
                esac
                ;;
            ?)
                echoerr 'what are you doing'
                exit 1
                ;;
            esac
        done
    shift $(($OPTIND - 1))
    SYMFILE=$1
    if [ -z $SYMFILE ]
        then
            echoerr 'symbol file should always be specified'
            exit 1
    fi
}


sum_up()
{
MODULE=(
core/WebCore/rendering
core/WebCore/loader
core/WebCore/dom
core/WebCore/css/
core/WebCore/xml/
core/WebCore/html
core/WebCore/page
core/WebCore/history
core/WebCore/uc/history
core/WebCore/uc/adblock
core/WebCore/uc/business
core/WebCore/uc/page/uc
core/WebCore/uc/corecommon
core/WebCore/uc/platform/network 
core/WebCore/storage
core/WebCore/uc/loader
core/WebKit/android/ac/jni/PicturePile
core/WebCore/uc/platform/graphics/android/layers
core/WebCore/platform/SharedBuffer
core/WebCore/platform/sql/SQLiteDatabase.cpp
android::WebViewCore::createBaseLayer
core/v8/out/../src/builtins
core/WebCore/uc/platform/graphics
core/WebKitLibraries/libskia-gpu/
core/WebKit/android/share/jni
core/WebKit/android/ac/jni/
core/JavaScriptCore/wtf/ThreadingPthreads
data/huangmy/u3/m10/m10code
system/lib/libsqlite.so
system/lib/libskia.so
/data/local/tmp/libmemanaly.so
/system/lib/libutils.so
/data/local/tmp/libstagefright.so
BrowserShell/platform/android/bridge/JNIEnvProxy
BrowserShell/utility/text
BrowserShell/platform/android/bridge/bitmap
/BrowserShell/bridge/RunEngine
/BrowserShell/platform/android/bridge/ModelAgentBridge
BrowserShell/platform/android/uidl/
/BrowserShell/bridge/ActivityBoot
/BrowserShell/platform/android/bridge/BreakpadClient
/BrowserShell/service
BrowserShell/adaptation/
BrowserShell/model/addon
BrowserShell/base
BrowserShell/jni/data
BrowserShell/utility/xml
BrowserShell/platform/android/bridge/LoadListenerShellBridge
BrowserShell/jni/service/UcServiceBase
BrowserShell/model/novel
BrowserShell/bridge/ServiceManagerBridge
BrowserShell/platform/android/bridge/JNI_Register
)
declare -p ACC
declare -a MODULEACC
    while read ADDR  && read SYM && read LINEINFO
        do
            for (( i=0; i<${#MODULE[@]} ; ++i ))
            do
                m=${MODULE[$i]}
                if [[ $LINEINFO =~ $m ]]
                    then
                        echo ${ACC[$ADDR]}
                        ((MODULEACC[$i]+=${ACC[$ADDR]}))
                fi
            done
        done
    for (( i=0; i<${#MODULE[@]} ; ++i ))
    do
        m=${MODULE[$i]}
        size=${MODULEACC[i]}
        echo $m,$size
        
    done
}

build_acc()
{
    while read ADDR SIZE SYM
    do
        ACC[0x$ADDR]=$SIZE
    done
    
    ${PREFIX}addr2line -afCe $SYMFILE `printf -- "%x " "${!ACC[@]}"` | sum_up 
            
}

setup_option $*


# we use readelf -s to generate the symbole information
# then use tail -n+3 to skip the first three lines for 
# that information.
# Then this pipeline skip the symbols whose size is 0 or
# address is 0
# At this time the pipeline outputs an associative array
# whose key is an address and value is a symbol name
# Then we use address to line and get the sum up the 
# path info

${PREFIX}readelf -W -s $SYMFILE | awk '
BEGIN { FOUNDSYMTABLE = 0 }
{
    if (FOUNDSYMTABLE == 0)
    {
        if (match ($0, "^Symbol table '"'"'.symtab'"'"' contains"))
        {
            FOUNDSYMTABLE = 1
        }
        next
    }
    if (FOUNDSYMTABLE <= 3)
    {
        FOUNDSYMTABLE++
        next
    }
    if (FOUNDSYMTABLE > 3 && $3 != 0)
        print $2,$3,$8
}
' | build_acc



exit 0
