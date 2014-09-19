#!/bin/bash
N=$1
ON=${1%*.*}.mp4

avconv $INPUT_OPT -i $N -c:v libx264 -strict experimental -c:a aac $OUTPUT_OPT $ON 
