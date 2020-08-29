#!/usr/bin/python3

# check your python3 path:
# >which python3

# make this script executable:
# >chmod u+x AlchitryCu_UART.py

#################################################
# import useful constants and methods from sys

from sys import version
from sys import argv
from sys import exit

# import useful constants and methods from sys
#################################################

print("file: AlchitryCu_UART.py")
print("content: Alchitry Cu UART test script")
print("created: 2020 August 8 Saturday")
print("author: roch schanen")
print("comment: test UART communication with the Alchitry Cu FPGA")
print("run Python3:" + version);

# check usb device

# >lssub
# Bus 001 Device 013: 
# ID 0403:6010 Future Technology Devices International,
# Ltd FT2232C/D/H Dual UART/FIFO IC

# serial communication installation using (check web-pages):

# >pip3 install pyvisa
# >pip3 install pyserial
# >pip3 install pyvisa-py

# check installation:

# >pyvisa-info 
# Machine Details:
#    Platform ID:    Linux-5.4.0-42-generic-x86_64-with-glibc2.29
#    Processor:      x86_64
# Python:
#    Implementation: CPython
#    Executable:     /usr/bin/python3
#    Version:        3.8.2
#    Compiler:       GCC 9.3.0
#    Bits:           64 bit
#    Build:          July 16 2020 14:00:26 (#default)
#    Unicode:        UCS4
# PyVISA Version: 1.10.1
# Back ends:
#    ni:
#       Version: 1.10.1 (bundled with PyVISA)
#       Binary library: Not found
#    py:
#       Version: 0.4.1
#       ASRL INSTR: Available via PySerial (3.4)
#       USB INSTR:
#          Please install PyUSB to use this resource type.
#          No module named 'usb'
#       USB RAW:
#          Please install PyUSB to use this resource type.
#          No module named 'usb'
#       TCPIP INSTR: Available 
#       TCPIP SOCKET: Available 
#       GPIB INSTR:
#          Please install linux-gpib (Linux) or gpib-ctypes (Windows,
#          Linux) to use this resource type. Note that installing
#          gpib-ctypes will give you access to a broader range of
#          functionality.
#          No module named 'gpib'

# instrument name found on the local machine

# >python3
# >>>import pyvisa
# >>>rm = pyvisa.ResourceManager()
# >>>print(rm.list_resources())
# prints the available instruments name
# ( 'ASRL/dev/ttyS4::INSTR', 
#   'ASRL/dev/ttyS0::INSTR',
#   'ASRL/dev/ttyUSB1::INSTR',
#   'ASRL/dev/ttyUSB0::INSTR'
# )

# ttyUSB0 is used to program the Alchitry Cu EEPROM
# ttyUSB1 is used for communicating with the configured FPGA

# there is an issue here. The indexing of the ttyUSBx devices
# depends on the order the USB devices are found. This might
# lead to misidentification of the ports on different systems.
# I could not find in the documentation a proper way to do this
# using the pyvisa library. some configuration set-up is needed
# to identify the Alchitry device twin ports.

# find attributes to identify an Alchitry Device
# connected to an USB port and to build an automated
# rule for symbolic linking to the device:

#>udevadm info --name=/dev/ttyUSB0 --attribute-walk

# I collected the following relevant attributes
# SUBSYSTEMS=="usb-serial"
# FT2232H identification: (this is the USB chip connecting the Alchitry board)
# ATTRS{idVendor}=="0403"
# ATTRS{idProduct}=="6010"
# serial number:
# ATTRS{serial}=="FT3WSDT8" (This might be a unique number. need confirmation.)
# Interface:
# ATTRS{interface}=="Alchitry Cu"
# ATTRS{bInterfaceNumber}=="00" or "01"

# the following should identify unequivocally the device:

# the programming port
# ATTRS{interface}=="Alchitry Cu"
# ATTRS{bInterfaceNumber}=="00"
#
# the communication port
# ATTRS{interface}=="Alchitry Cu"
# ATTRS{bInterfaceNumber}=="01"

# make rules:
# ATTRS{interface}=="Alchitry Cu", ATTRS{bInterfaceNumber}=="01", GROUP="plugdev", MODE="0666", SYMLINK+="AlCuCOM"

# use:
# sudo nano /etc/udev/rules.d/99-USB-AlchitryCu.rules

# plug the Alchitry Cu board -> the serial device "/dev/AlCuCOM" should be present and visible

# udev recognise correctly the Alchitry Cu device when plugging it in.
# However, the simlink /dev/AlCuCOM is not listed by pyvisa.
# But the pyserial library does list the simlink.
# Also, the pyserial can identify the serial device by its attributes.
# Hence, the "/dev/AlCuCOM" symlink is not really necessary to identify the Alchitry device.
# The rule "99-USB-AlchitryCu.rules" is therefore removed.
# and we use the pyserial methods to detect the device.


#################################################
# import useful constants and methods from serial

from serial.tools.list_ports import comports

# import useful constants and methods from serial
#################################################

# the following makes sure that we always point to the correct Alchitry UART port

AlCuName = None

# for p in comports(include_links = True):
#     if p.device == '/dev/AlCuCOM':
#         print(f'Found {p.device} at {p.name}.')
#         AlCuName = f"ASRL/dev/{p.name}::INSTR"
#         print(f'Build VISA resource name "{AlCuName}".')

# if not AlCuName:
#     print("'/dev/AlCuCOM' SYMLINK not found. Exiting...")
#     exit(0)

for p in comports():
    if p.product == 'Alchitry Cu':
        if p.location == '1-1.3:1.1':
            print(f'Found "{p.product}" device.')
            print(f'Found "{p.location}" location.')
            # built compliant VISA resource name        
            AlCuName = f"ASRL/dev/{p.name}::INSTR"
            print(f'Build VISA resource name "{AlCuName}".')

if not AlCuName:
    print("'/dev/AlCuCOM' SYMLINK not found. Exiting...")
    exit(0)

# todo: we might want to perform all serial communication 
# using only one library. pyvisa or pyserial but not both.

#################################################
# import useful constants and methods from pyvisa

from pyvisa.constants import VI_ASRL_STOP_ONE
from pyvisa.constants import VI_ASRL_STOP_ONE5
from pyvisa.constants import VI_ASRL_STOP_TWO
stop_bits_constants = {
    VI_ASRL_STOP_ONE    :   "1.0",
    VI_ASRL_STOP_ONE5   :   "1.5",
    VI_ASRL_STOP_TWO    :   "2.0"
}

from pyvisa.constants import VI_ASRL_END_BREAK
from pyvisa.constants import VI_ASRL_END_NONE
from pyvisa.constants import VI_ASRL_END_TERMCHAR
from pyvisa.constants import VI_ASRL_END_LAST_BIT
end_input_constant = {
    VI_ASRL_END_BREAK       : "Break",
    VI_ASRL_END_NONE        : "None",
    VI_ASRL_END_TERMCHAR    : "TermChar",
    VI_ASRL_END_LAST_BIT    : "LastBit"
}

from pyvisa.constants import VI_ASRL_PAR_EVEN
from pyvisa.constants import VI_ASRL_PAR_MARK 
from pyvisa.constants import VI_ASRL_PAR_NONE
from pyvisa.constants import VI_ASRL_PAR_ODD
from pyvisa.constants import VI_ASRL_PAR_SPACE
parity_constants = {
    VI_ASRL_PAR_EVEN    : "Even",
    VI_ASRL_PAR_MARK    : "Mark",
    VI_ASRL_PAR_NONE    : "None",
    VI_ASRL_PAR_ODD     : "Odd",
    VI_ASRL_PAR_SPACE   : "Space"
}

from pyvisa import ResourceManager

# import useful constants and methods from pyvisa
#################################################


# instantiate the ResourceManager
rm = ResourceManager()

# if argv[1] == "list":
#     print(rm.list_resources())
#     exit(0)

# instantiate the instrument
if not AlCuName in rm.list_resources():
    print(f'{AlCuName} not found. Exiting...')
    exit(0)

# open session
print(f"Open port {AlCuName}")
AlCu = rm.open_resource(AlCuName)

# change transmission rate
AlCu.baud_rate = 781250 # 100MHz / 2^7

# change termination string
AlCu.write_termination = ""

# display set-up
print(f"Baud rate = {AlCu.baud_rate} bit/s")
print(f"Data bits = {AlCu.data_bits} bits")
print(f"Stop bits = {stop_bits_constants[AlCu.stop_bits]} bit(s)")
print(f"Parity    = {parity_constants[AlCu.parity]}")
print(f"termination string = '{AlCu.write_termination}'")

# get value from command line
v = int(f'0b{argv[1]}',2)

# convert to bytes
b = v.to_bytes(1,'big')

# display
v = int.from_bytes(b, 'big')
print(f'write 1 byte "{argv[1]}"')

# write one byte
AlCu.write_raw(b)

# get one byte
b = AlCu.read_bytes(1)

# display
v = int.from_bytes(b, 'big')
print(f'read  1 byte "{v:08b}"')

# close session
AlCu.close()

# usage:
#
# to send an 8 bits binary string to the Alchitry Cu device:
# type AlchitryCu_UART.py BBBBBBBB where B = '0' or '1'.
#
# example:
#
# >./AlchitryCu_UART.py 01010101
# file: AlchitryCu_UART.py
# content: Alchitry Cu UART test script
# created: 2020 August 8 Saturday
# author: roch schanen
# comment: test UART communication with the Alchitry Cu FPGA
# run Python3:3.8.2 (default, Jul 16 2020, 14:00:26) 
# [GCC 9.3.0]
# Found "Alchitry Cu" device.
# Found "1-1.3:1.1" location.
# Build VISA resource name "ASRL/dev/ttyUSB2::INSTR".
# Open port ASRL/dev/ttyUSB2::INSTR
# Baud rate = 781250 bit/s
# Data bits = 8 bits
# Stop bits = 1.0 bit(s)
# Parity    = None
# termination string = ''
# write 1 byte "01010101"
# read  1 byte "01010101"
# >
