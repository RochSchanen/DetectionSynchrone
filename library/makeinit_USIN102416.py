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

print("file: makeinit_USIN102416.py")
print("content: make init data for USIN102416")
print("created: 2020 september 5")
print("author: roch schanen")
print("comment:")
print("run Python3:" + version);

from numpy import pi, sin

# AL = int(argv[1])
AL = 10	   # address size
AS = 2**AL # address length

# DL = int(argv[2])
DL = 16		 # data size
DS = 2**DL-1 # data length

# build data
RAM3, RAM2, RAM1, RAM0 = [], [], [], []
for i in range(AS):
	x = 2.0*pi/AS*i
	y = (1.0+sin(x))/2.0
	s = f'{int(DS*y):04x}'
	RAM3.append(s[0])
	RAM2.append(s[1])
	RAM1.append(s[2])
	RAM0.append(s[3])

# print init code
n = 0
for r in [RAM3, RAM2, RAM1, RAM0]:
	r.reverse()
	s = ''.join(r)
	print('        generic map (')
	for n in range(16):
		print(f'INIT_{n:X} => X"{s[-64:]}"', end='')
		s = s[:-64]
		if n == 15: print(')')
		else: print(',')

# >./makeinit_SIN102416.py
# file: makeinit_USIN102416.py
# content: make init data for USIN102416
# created: 2020 september 5
# author: roch schanen
# comment:
# run Python3:3.8.2 (default, Jul 16 2020, 14:00:26) 
# [GCC 9.3.0]
#         generic map (
# INIT_0 => X"baaaaaaaaaaaaaaaaaaaaa999999999999999999999888888888888888888887",
# INIT_1 => X"dddddddddddddddddcccccccccccccccccccccccccbbbbbbbbbbbbbbbbbbbbbb",
# INIT_2 => X"ffffffffffffffffffeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeddddddddddd",
# INIT_3 => X"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
# INIT_4 => X"ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff",
# INIT_5 => X"ddddddddddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeefffffffffffffffffff",
# INIT_6 => X"bbbbbbbbbbbbbbbbbbbbbcccccccccccccccccccccccccdddddddddddddddddd",
# INIT_7 => X"88888888888888888888999999999999999999999aaaaaaaaaaaaaaaaaaaaabb",
# INIT_8 => X"4555555555555555555555666666666666666666666777777777777777777777",
# INIT_9 => X"2222222222222222233333333333333333333333334444444444444444444444",
# INIT_A => X"0000000000000000001111111111111111111111111111111111122222222222",
# INIT_B => X"0000000000000000000000000000000000000000000000000000000000000000",
# INIT_C => X"0000000000000000000000000000000000000000000000000000000000000000",
# INIT_D => X"2222222222111111111111111111111111111111111110000000000000000000",
# INIT_E => X"4444444444444444444443333333333333333333333333222222222222222222",
# INIT_F => X"7777777777777777777766666666666666666666655555555555555555555544")
#         generic map (
# INIT_0 => X"0feedcbba9887655432210ffedccba9887655432210feedcbaa987765433210f",
# INIT_1 => X"99887765544332110ffeedccbaa998776554332110ffeddcbaa9887665433210",
# INIT_2 => X"555544433322111000ffeeeddcccbbaa999887766554433221100ffeeddccbba",
# INIT_3 => X"ffffffffffffffffffffeeeeeeeedddddddcccccbbbbbaaaaa99998887777666",
# INIT_4 => X"6677778889999aaaaabbbbbcccccdddddddeeeeeeeefffffffffffffffffffff",
# INIT_5 => X"bbccddeeff001122334455667788999aabbcccddeeeff0001112233344455556",
# INIT_6 => X"123345667889aabcddeff011233455677899aabccdeeff01123344556778899a",
# INIT_7 => X"012334567789aabcdeef0122345567889abccdeff0122345567889abbcdeef00",
# INIT_8 => X"f0112344567789aabcddef0012334567789aabcddef0112345567889abccdeff",
# INIT_9 => X"6677889aabbccdeef0011233455667889aabccdeef001223455677899abccdef",
# INIT_A => X"aaaabbbcccddeeefff00111223334455666778899aabbccddeeff00112233445",
# INIT_B => X"0000000000000000000011111111222222233333444445555566667778888999",
# INIT_C => X"9988887776666555554444433333222222211111111000000000000000000000",
# INIT_D => X"4433221100ffeeddccbbaa99887766655443332211100fffeeeddcccbbbaaaa9",
# INIT_E => X"edccba998776554322100feedccbaa9887665543321100feedccbbaa98877665",
# INIT_F => X"fedccba9887655432110feddcbaa9877654332100feddcbaa9877654432110ff")
#         generic map (
# INIT_0 => X"48c159d16ae26ae26ae269d159c048bf36ae158c037ae158cf36ad147be259cf",
# INIT_1 => X"f6d4a18f5c3906c39f5b28e39f5b06c17c27c27c27c16b05af38d26b049d26bf",
# INIT_2 => X"fa50b50b50a5f94e82c5f92c6f82b4d6f81a3b4c5d6e6e7f7f6e6e5d4c3b2908",
# INIT_3 => X"ffffeeedccba98764320edb97531fdb8630eb852fc952eb740c840c83fb62d84",
# INIT_4 => X"8d26bf38c048c047be259cf258be0368bdf13579bde02346789abccdeeefffff",
# INIT_5 => X"092b3c4d5e6e6f7f7e6e6d5c4b3a18f6d4b28f6c29f5c28e49f5a05b05b05af4",
# INIT_6 => X"b62d940b62d83fa50b61c72c72c72c71c60b5f93e82b5f93c6093c5f81a4d6f8",
# INIT_7 => X"c952eb741da63fc851ea730c851ea63fb840c951d962ea62ea62ea61d951c84f",
# INIT_8 => X"b73ea62e951d951d951d962ea63fb740c951ea73fc851ea730c952eb841da63f",
# INIT_9 => X"092b4e7093c6f93c60a3d71b60a4f93e83d82d83d83e94fa50b72d94fb62d940",
# INIT_A => X"05af4af4af5a06b17d3a06c3907d4b2907e5c4b3a2919180809191a2a3c4d6e7",
# INIT_B => X"0000011233456789bcdf02468ace02479cf147ad036ad148bf37bf37b049d27b",
# INIT_C => X"72d940b73fb73fb841da630da741fc97420eca86420fdcb98765433211000000",
# INIT_D => X"e6d4c3a2a1919080819192a3b4c5e7092b4d7093c60a3d71b60a5fa4fa4fa50b",
# INIT_E => X"49d26bf49d27b05af49e38d38d28d38e39f4a06b17d3a06c39f6c3907e4b2907",
# INIT_F => X"36ad148be259c037ae158cf37ae159c047bf36ae269d159d159d159e26ae37b0")
#         generic map (
# INIT_0 => X"16b048be1346677765431ec962ea62d82d71b4e7092a2b3b3a2a1807e5c3a18f",
# INIT_1 => X"3332fd94f92a18e27adf000fda73e92c4c3af49d0356777542fc83e93c5e6d4b",
# INIT_2 => X"34431ea4e6e49d01220ea5f918e37abccb851c5e6d27be0110eb72d6f6d38cf1",
# INIT_3 => X"ec95f807d1466641c708f49ceeec950918e26898741c5e5c14799863f93b28d0",
# INIT_4 => X"d82b39f36899741c5e5c14789862e819059ceeec94f807c1466641d708f59cef",
# INIT_5 => X"fc83d6f6d27be0110eb72d6e5c158bccba73e819f5ae02210d94e6e4ae134430",
# INIT_6 => X"4d6e5c39e38cf2457776530d94fa3c4c29e37adf000fda72e81a29f49df23331",
# INIT_7 => X"81a3c5e7081a2a3b3b2a2907e4b17d28d26ae269ce1345677766431eb840b61b",
# INIT_8 => X"d83ea630dba8877789abd0258c048c16c17d3a07e5c4c3b3b4c4d6e7092b4d6f",
# INIT_9 => X"bbbcf15af5c4d60c741feeef147b05c2a2b4fa51eb987779acf26b05b29081a3",
# INIT_A => X"baabd04a080a51edcce049f5d60b74322369d29081c730edde037c18f81b62fd",
# INIT_B => X"0259f6e71da888ad27e6fa52000259e5d60c86567ad29092da75568bf5b3c61e",
# INIT_C => X"16c3b5fb86557ad29092da76568c06d5e95200025af6e72da888ad17e6f95200",
# INIT_D => X"f26b18f81c730edde037c18092d96322347b06d5f940eccde15a080a40dbaabe",
# INIT_E => X"a18092b50b62fca977789be15af4b2a2c50b741feeef147c06d4c5fa51fcbbbd",
# INIT_F => X"6d4b2907e6d4c4b3b3c4c5e70a3d71c61c840c8520dba9877788abd036ae38d3")
