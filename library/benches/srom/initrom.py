#!/usr/bin/python3

# check your python3 path:
# >which python3

# make this script executable:
# >chmod u+x initrom.py

################################################
# import useful constants and methods from sys

from sys import version
from sys import argv

# import useful constants and methods from sys
#################################################

# produce init rom text 
# least significant bits on the right hand side
# lost significant bits on the left hand side
# data grouped in hexadecimal
# INIT_0 => X"0000000000000000000000000000000000000000000000000000000000000000",
# ...
# INIT_F => X"0000000000000000000000000000000000000000000000000000000000000000"

print("file: initrom.py")
print("content: produce rom data to copy in rom.vhd")
print("created: 2020 september 2")
print("author: roch schanen")
print("comment:")
print("run Python3:" + version);

from numpy import pi, sin

# AL = int(argv[1])
AL = 9 		# address size
AS = 2**AL  # address length


# DL = int(argv[2])
DL = 8 				# data size
DS = 2**DL-1 	# data length

fn = f"SIN{AS}x{DL}.txt"
print(f"make {fn}")

l, s = 0, ''
fh = open(fn, 'w')
for i in range(AS):
	if l % 32 == 0:
		fh.write(f',\nINIT_{l//32-1:X} => X"{s}"')
		s = ''
	x = 2.0*pi/AS*i
	y = (1.0+sin(x))/2.0
	# fh.write(f'{int(DS*y):0{DL}b}\n')
	# fh.write(f'{int(DS*y):02x}')
	s = f'{int(DS*y):02x}{s}'
	l += 1
fh.write(f',\nINIT_{l//32-1:X} => X"{s}")')
fh.close()

# EXAMPLE:
# >./initrom.py 
# file: initrom.py
# content: produce rom data to copy in rom.vhd
# created: 2020 september 2
# author: roch schanen
# comment:
# run Python3:3.8.2 (default, Jul 16 2020, 14:00:26) 
# [GCC 9.3.0]
# make SIN512x8.txt

