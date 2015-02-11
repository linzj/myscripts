#!/bin/bash
if [ $# -le 0 ]
then
    echo "pid should be provided" 1>&2
    exit 1
fi
while [ -d /proc/$1 ]
    do
        sleep 10
    done
shutdown -P now
