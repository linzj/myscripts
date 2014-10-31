#!/bin/bash
shopt -s nocaseglob
DIR="$1"
shift
SUFFIX="$1"
shift

COUNT=1

DIRS="$#"

IFS=`printf "\n"`

do_move()
{
    TARGET="$1"
    for f in $TARGET/*.${SUFFIX}
        do
            cp "$f" `printf "$DIR"/%03d.${SUFFIX} ${COUNT}`
            ((COUNT++))
        done
}

while [ $DIRS -ne 0 ]
    do
        if [ -d "$1" ]
            then
                do_move "$1"
        fi
        shift
        ((DIRS--))
    done
