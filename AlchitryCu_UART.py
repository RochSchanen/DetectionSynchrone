#!/usr/bin/python3

# check python3 path
# >which python3

# check usb device
# >lssub
# Bus 001 Device 013: 
# ID 0403:6010 Future Technology Devices International,
# Ltd FT2232C/D/H Dual UART/FIFO IC

# serial communication installation using (ckeck webpages):
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
#    Bits:           64bit
#    Build:          Jul 16 2020 14:00:26 (#default)
#    Unicode:        UCS4
# PyVISA Version: 1.10.1
# Backends:
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
#          Please install linux-gpib (Linux) or gpib-ctypes (Windows, Linux) to use this resource type. Note that installing gpib-ctypes will give you access to a broader range of funcionality.
#          No module named 'gpib'

# intrument name found the local machine
# >python3
# >>>import pyvisa
# >>>rm = pyvisa.ResourceManager()
# >>>print(rm.list_resources())
# prints the available intruments name
# (	'ASRL/dev/ttyS4::INSTR', 
# 	'ASRL/dev/ttyS0::INSTR',
# 	'ASRL/dev/ttyUSB1::INSTR',
# 	'ASRL/dev/ttyUSB0::INSTR'
# )
# ttyUSB0 is used to program the Alchitry Cu EEPROM
# ttyUSB1 is used for communicating with the configured FPGA

# make executable
# >chmod u+x AlchitryCu_UART.py

# usage:
# >./AlchitryCu_UART.py

PORTNAME = 'ASRL/dev/ttyUSB1::INSTR'

#################################################
# import useful constants and methods from pyvisa

from pyvisa.constants import VI_ASRL_STOP_ONE
from pyvisa.constants import VI_ASRL_STOP_ONE5
from pyvisa.constants import VI_ASRL_STOP_TWO
stop_bits_constants = {
	VI_ASRL_STOP_ONE 	:	"1.0",
	VI_ASRL_STOP_ONE5 	:	"1.5",
	VI_ASRL_STOP_TWO 	:	"2.0"
}

from pyvisa.constants import VI_ASRL_END_BREAK
from pyvisa.constants import VI_ASRL_END_NONE
from pyvisa.constants import VI_ASRL_END_TERMCHAR
from pyvisa.constants import VI_ASRL_END_LAST_BIT
end_input_constant = {
	VI_ASRL_END_BREAK 		: "Break",
	VI_ASRL_END_NONE 		: "None",
	VI_ASRL_END_TERMCHAR	: "TermChar",
	VI_ASRL_END_LAST_BIT	: "LastBit"
}

from pyvisa.constants import VI_ASRL_PAR_EVEN
from pyvisa.constants import VI_ASRL_PAR_MARK 
from pyvisa.constants import VI_ASRL_PAR_NONE
from pyvisa.constants import VI_ASRL_PAR_ODD
from pyvisa.constants import VI_ASRL_PAR_SPACE
parity_constants = {
	VI_ASRL_PAR_EVEN 	: "Even",
	VI_ASRL_PAR_MARK 	: "Mark",
	VI_ASRL_PAR_NONE 	: "None",
	VI_ASRL_PAR_ODD 	: "Odd",
	VI_ASRL_PAR_SPACE 	: "Space"
}

from pyvisa import ResourceManager

# import useful constants and methods from pyvisa
#################################################

import sys

print("file: AlchitryCu_UART.py")
print("content: Alchitry Cu UART tester")
print("created: 2020 August 8 Saturday")
print("author: roch schanen")
print("comment: test UART communication with the FPGA")
print("run Python3:" + sys.version);

# instanciate the ResourceManager
rm = ResourceManager()

# instanciate the instrument
if PORTNAME in rm.list_resources():
	print(f"Open port {PORTNAME}")
	AlCu_UART = rm.open_resource(PORTNAME)
	AlCu_UART.baud_rate = 781250 # 100MHz / 2^7
	print(f"Baud rate = {AlCu_UART.baud_rate} bit/s")
	print(f"Data bits = {AlCu_UART.data_bits} bits")
	print(f"Stop bits = {stop_bits_constants[AlCu_UART.stop_bits]} bit(s)")
	print(f"Parity    = {parity_constants[AlCu_UART.parity]}")

AlCu_UART.write("Z")
print(f"-{AlCu_UART.read()}-")

AlCu_UART.close()
