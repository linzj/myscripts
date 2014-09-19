#!/bin/bash
N=$1
ON=${1%*.*}.mp4

avconv -i $N -c:v libx264 -strict experimental -c:a aac $ON
