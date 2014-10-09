APKFILE=$1
KEYSTOREFILE=$2
ERROR=0
echoerror ()
{
    echo $* 1>&2
}
if [ $# -lt 2 ]
    then
        echoerror 'need at least 2 args: <apk file> <key store path>'
        ERROR=1
fi


if ! [ -f $APKFILE ]
    then
        echoerror "apk file $APKFILE is not a regular file"
        ERROR=1
fi

if ! [ -f $KEYSTOREFILE ]
    then
        echoerror "keystore file $KEYSTOREFILE is not a regular file"
        ERROR=1
fi

if ! [ -f ~/apktool-cli.jar ]
    then
    echoerror "~/apktool-cli.jar is not a regular file"
    ERROR=1
fi

if ! which ucsignapk >/dev/null
    then
        echoerror "ucsignapk is not in your PATH variable"
        ERROR=1
fi

if [ $ERROR -ne 0 ]
    then
        exit 1
fi

# unpack apk

if ! java -jar ~/apktool-cli.jar d $APKFILE
    then
        echoerror "java -jar ~/apktool-cli.jar d $APKFILE command failed"
        exit 1
fi

if ! cd ${APKFILE%*.*}
    then
        echoerror "fails to cd to ${APKFILE%*.*}"
        exit 1
fi

# modify AndroidManifest.xml debuggable

if ! sed -i -e 's/debuggable="false"/debuggable="true"/' AndroidManifest.xml
    then
        echoerror "sed command fails"
        exit 1
fi

# repack here
if ! java -jar ~/apktool-cli.jar build
    then
        echoerror "repack apk fails"
        exit 1
fi

# cd back
cd ..

# test output file
if ! [ -f ${APKFILE%*.*}/dist/$APKFILE ]
    then
        echoerror "apktool does not output to ${APKFILE%*.*}/dist/$APKFILE"
        exit 1
fi

# mv original

if ! mv $APKFILE ${APKFILE}.backup
    then
        echoerror "fails to mv $APKFILE to ${APKFILE}.backup"
        exit 1
fi


# sign here
if ! ucsignapk  ${APKFILE%*.*}/dist/$APKFILE  $APKFILE $KEYSTOREFILE
    then
        echoerror "fails to invoke ucsignapk ${APKFILE%*.*}/dist/$APKFILE  $APKFILE $KEYSTOREFILE"
        exit 1
fi

echo "Successfully output!"

exit 0
