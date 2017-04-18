#!/usr/bin/python

import sys
import struct

if __name__ == '__main__':

    numberArray =[]
    for numstring in sys.argv[1:] :
        numberArray.append(int(numstring,16))

    outputString = ''.join([struct.pack('@I',num) for num in numberArray])
    with  open('dump','wb') as f:
        f.write(outputString)
