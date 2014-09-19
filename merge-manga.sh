#!/bin/sh
DIR=$1
shift

COUNT=1

DIRS=$#

do_move()
{
    TARGET=$1
    for f in `ls $TARGET/*.png`
        do
            cp $f `printf $DIR/%03d.png ${COUNT}`
            ((COUNT++))
        done
}

while [ $DIRS -ne 0 ]
    do
        if [ -d $1 ]
            then
                do_move $1
        fi
        shift
        ((DIRS--))
    done
