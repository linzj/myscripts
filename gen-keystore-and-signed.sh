if [ $CREATE_KEY_STORE ]
then
    keytool -genkey -alias signFiles -keystore examplestore
elif [ $# -ge 1 ]
then
    jarsigner -verbose -keystore  examplestore $1 signFiles
fi
