# /binaries/readme.md

Binary files used to test hardware installation.  
The binary files have been tested to work on the AlchitryCu.

	1) Check Alchitry loader with "AlchitryOriginal.bin"

AlchitryOriginal.bin is the original binary file that is shipped with
the alchitry board.  

Plug the board and check available devices:

>\>~/alchitry-loader-1.0.0/tools/loader -l  
Devices:  
  0: Alchitry Cu  
  1: Unknown  

Load the configuration file to the flash memory:

>\>~/alchitry-loader-1.0.0/tools/loader -f AlchitryOriginal.bin  
Resetting...  
cdone: low  
flash ID: 0xEF 0x40 0x16 0x00  
Programming...  
100%  
cdone: high  
Done.  


Leds should now display a wavy pattern.  
press the reset button should display a fixed alternate pattern.

	2) Check the alternate IceStorm loader with "AlchitryOriginal.bin".  

Plug the board and load the configuration file to the flash memory:

>\>iceprog AlchitryOriginal.bin  
init..  
cdone: high  
reset..  
cdone: low  
flash ID: 0xEF 0x40 0x16 0x00  
file size: 135100  
erase 64kB sector at 0x000000..  
erase 64kB sector at 0x010000..  
erase 64kB sector at 0x020000..  
programming..  
reading..  
VERIFY OK  
cdone: high  
Bye.  
AlchitryBlink.bin  
leds should now display a wavy pattern.  
press the reset button should display a fixed alternate pattern.  

	3) check the UART setup:

load the binary file to the flash memory:

>\>iceprog AlchitryCu_UART.bin  
init..  
cdone: high  
reset..  
cdone: low  
flash ID: 0xEF 0x40 0x16 0x00  
file size: 135180  
erase 64kB sector at 0x000000..  
erase 64kB sector at 0x010000..  
erase 64kB sector at 0x020000..  
programming..  
reading..  
VERIFY OK  
cdone: high  
Bye.  

Run the python3 script to send a series of 8 bits:

>\>./AlchitryCu_UART.py 01010101  
file: AlchitryCu_UART.py  
content: Alchitry Cu UART test script  
created: 2020 August 8 Saturday  
author: roch schanen  
comment: test UART communication with the Alchitry Cu FPGA  
run Python3:3.8.2 (default, Jul 16 2020, 14:00:26)  
[GCC 9.3.0]  
Found "Alchitry Cu" device.  
Found "1-1.3:1.1" location.  
Build VISA resource name "ASRL/dev/ttyUSB1::INSTR".  
Open port ASRL/dev/ttyUSB1::INSTR  
Baud rate = 781250 bit/s  
Data bits = 8 bits  
Stop bits = 1.0 bit(s)  
Parity    = None  
termination string = ''  
write 1 byte "01010101"  
read  1 byte "01010101"  

Leds should now display the pattern 01010101.  
Try other binary string to check all leds.  
Reset has no action.
