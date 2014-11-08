#!/bin/bash
find -regextype posix-extended -iregex '.*\.(c|cpp|h|hpp|java|cc)$' >/tmp/__cscope__.lst
cscope -b -i /tmp/__cscope__.lst
rm /tmp/__cscope__.lst
