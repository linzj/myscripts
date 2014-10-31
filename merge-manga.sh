#!/bin/bash
shopt -s nocaseglob
shopt -s extglob
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
    FUNCTION_SUFFIX='@('"${SUFFIX}"')'
    for f in $TARGET/*.${FUNCTION_SUFFIX}
        do
            cp "$f" `printf "$DIR"/%03d.${f#*.} ${COUNT}`
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
