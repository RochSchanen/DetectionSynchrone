-- ########################################################

-- file: srom.vhd
-- content: static rom
-- Created: 2020 september 02
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- geometry is 512 pts (9 bits address) of resolution 8 bits

-- ########################################################


-------------------------------------------------
--                   SROM
-------------------------------------------------

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library sb_ice40_components_syn;
use sb_ice40_components_syn.components.all;

-------------------------------------------------

entity srom is
    port(        
        a : in  std_logic_vector (8 downto 0);   -- address (9 bits)
        t : in  std_logic;                       -- trigger (rising edge)
        o : out std_logic_vector (7 downto 0));  -- data (8 bits)
end entity srom;

-------------------------------------------------

architecture srom_arch of srom is

begin

    ram1 : SB_RAM512x8

        -- pre-loaded with a full period sinusoid over the range 0-255 and centered at 127
        -- least significant bits on the left
        -- most significant bits on the right
        -- memory split into 16 strings
        -- binary format stored in pairs of hexadecimal characters representing 8 bits.

        generic map (
            INIT_0 => X"aeadabaaa8a7a6a4a3a19f9e9c9b999896959392908f8d8b8a8887858482817f", -- center
            INIT_1 => X"d8d7d6d5d3d2d1d0cfcdcccbcac8c7c6c5c3c2c1bfbebcbbbab8b7b6b4b3b1b0",
            INIT_2 => X"f4f4f3f2f2f1f0efefeeedececebeae9e8e7e6e5e4e4e3e2e1e0dfdddcdbdad9",
            INIT_3 => X"fefefefefefefefefefefdfdfdfdfcfcfcfbfbfbfafaf9f9f9f8f8f7f7f6f5f5",
            INIT_4 => X"f5f6f7f7f8f8f9f9f9fafafbfbfbfcfcfcfdfdfdfdfefefefefefefefefefeff", -- max
            INIT_5 => X"dadbdcdddfe0e1e2e3e4e4e5e6e7e8e9eaebececedeeefeff0f1f2f2f3f4f4f5",
            INIT_6 => X"b1b3b4b6b7b8babbbcbebfc1c2c3c5c6c7c8cacbcccdcfd0d1d2d3d5d6d7d8d9",
            INIT_7 => X"8182848587888a8b8d8f909293959698999b9c9e9fa1a3a4a6a7a8aaabadaeb0",
            INIT_8 => X"505153545657585a5b5d5f606263656668696b6c6e6f7173747677797a7c7d7f", -- center
            INIT_9 => X"262728292b2c2d2e2f31323334363738393b3c3d3f404243444647484a4b4d4e",
            INIT_A => X"0a0a0b0c0c0d0e0f0f10111212131415161718191a1a1b1c1d1e1f2122232425",
            INIT_B => X"0000000000000000000001010101020202030303040405050506060707080909",
            INIT_C => X"0908070706060505050404030303020202010101010000000000000000000000", -- min
            INIT_D => X"242322211f1e1d1c1b1a1a19181716151413121211100f0f0e0d0c0c0b0a0a09",
            INIT_E => X"4d4b4a484746444342403f3d3c3b39383736343332312f2e2d2c2b2928272625",
            INIT_F => X"7d7c7a7977767473716f6e6c6b696866656362605f5d5b5a585756545351504e")
        
        port map (
            -- read signals
            RDATA => o,      -- 'read' data
            RADDR => a,      -- 'read' address
            RCLK  => t,      -- 'read' clock          (rising edge)
            RCLKE => 'H',    -- 'read' clock enable   (active high)
            RE    => 'H',    -- 'read' enable         (active high)
            -- write signals
            WADDR => open,   -- 'write' data          (unused)
            WCLK  => open,   -- 'write' address       (unused)
            WCLKE => open,   -- 'write' clock         (unused)
            WDATA => open,   -- 'write' clock enable  (unused)
            WE    => 'L');   -- 'write' enable        (unused)

end architecture srom_arch;

-------------------------------------------------
