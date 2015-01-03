#!/bin/bash
N=$1
ON=${1%*.*}.mp4
COUNT=1
while [ -e "$ON" ]
do
    ON=${1%*.*}_$COUNT.mp4
    ((COUNT++))
done
avconv $INPUT_OPT -i "$N" -c:v libx264 -strict experimental -c:a aac $OUTPUT_OPT "$ON"
