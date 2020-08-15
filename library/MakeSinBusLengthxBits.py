#!/usr/bin/python3

# check your python3 path:
# >which python3

# make this script executable:
# >chmod u+x MakeSinBusLengthxBits.py

################################################
# import useful constants and methods from sys

from sys import version
from sys import argv

# import useful constants and methods from sys
#################################################

print("file: makerom.py")
print("content: make rom data file for srom.vhd device")
print("created: 2020 August 14")
print("author: roch schanen")
print("comment:")
print("run Python3:" + version);

from numpy import pi, sin

AL = int(argv[1])
AS = 2**AL

DL = int(argv[2])
DS = 2**DL-1

fn = f"SIN{AS}x{DL}.txt"
print(f"make {fn}")

fh = open(fn, 'w')
for i in range(AS):
	x = 2.0*pi/AS*i
	y = (1.0+sin(x))/2.0
	fh.write(f'{int(DS*y):0{DL}b}\n')

fh.close()

# EXAMPLE:
# >./MakeSinBusLengthxBits.py 8 8
# file: makerom.py
# content: make rom data file for srom.vhd device
# created: 2020 August 14
# author: roch schanen
# comment:
# run Python3:3.8.2 (default, Jul 16 2020, 14:00:26) 
# [GCC 9.3.0]
# make SIN256x8.txt
