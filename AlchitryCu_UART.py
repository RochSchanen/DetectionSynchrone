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

# python3 code:

import pyvisa
rm = pyvisa.ResourceManager()

# print(rm.list_resources())
# devices available
# ('ASRL/dev/ttyS4::INSTR', 'ASRL/dev/ttyS0::INSTR', 'ASRL/dev/ttyUSB1::INSTR')

AlCu_UART = rm.open_resource('ASRL/dev/ttyUSB1::INSTR')

AlCu_UART.write("hello 1")
AlCu_UART.write("hello 2")
AlCu_UART.write("hello 3")
AlCu_UART.write("hello 4")

print(f"|{AlCu_UART.read()}|")
print(f"|{AlCu_UART.read()}|")
print(f"|{AlCu_UART.read()}|")
print(f"|{AlCu_UART.read()}|")

AlCu_UART.close()

# >chmod u+x AlchitryCu_UART.py
# >./AlchitryCu_UART.py

# |hello 1
# |
# |hello 2
# |
# |hello 3
# |
# |hello 4
# |
