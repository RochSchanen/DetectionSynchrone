-- ########################################################

-- file: AlchitryCu.vhd
-- content: top device
-- Created: 2020 august 18
-- Author: Roch Schanen
-- comments:

-- ########################################################

-------------------------------------------------
--                ALCHITRYCU
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.components.all;

-------------------------------------------------

entity AlchitryCu is
    port(AlBr_IO_32 : out   std_logic;  -- Bank B 2
         AlBr_IO_33 : out   std_logic;  -- Bank B 5
         AlBr_IO_34 : out   std_logic;  -- Bank B 8
         AlBr_IO_35 : out   std_logic;  -- Bank B 11
         AlBr_IO_36 : out   std_logic;  -- Bank B 14
         AlBr_IO_37 : out   std_logic;  -- Bank B 17
         AlBr_IO_38 : out   std_logic;  -- Bank B 20
         AlBr_IO_39 : out   std_logic;  -- Bank B 23
         AlCu_CLOCK : in    std_logic); -- 100MHz clock
end entity AlchitryCu;

-------------------------------------------------

architecture arch of AlchitryCu is

    -- components

    component srom is
        port(        
            a : in std_logic_vector (8 downto 0);   -- address
            t : in std_logic;                       -- trigger (rising edge)
            o : out std_logic_vector (7 downto 0)); -- data
    end component srom;

    -- signals

    signal clk : std_logic;         -- slower clock
    signal acc : std_logic_vector(8 downto 0);
    signal o   : std_logic_vector(7 downto 0);

begin

    -- instanciate clock divider

    clkdiv1 : clkdiv
        generic map(10)              -- division by 1024
        port map(AlCu_CLOCK, clk);

    -- instanciate accumulator

    placc1_inst : placc
        generic map(9)
        port map('1', clk, acc);

    -- instanciate srom

    srom1 : srom
        port map(acc, clk, o);

    ---- output value

    AlBr_IO_32 <= o(7);
    AlBr_IO_33 <= o(6);
    AlBr_IO_34 <= o(5);
    AlBr_IO_35 <= o(4);
    AlBr_IO_36 <= o(3);
    AlBr_IO_37 <= o(2);
    AlBr_IO_38 <= o(1);
    AlBr_IO_39 <= o(0);

-- done
end architecture arch;

-------------------------------------------------





-------------------------------------------------
--                   SROM
-------------------------------------------------

-------------------------------------------------

library sb_ice40_components_syn;
use sb_ice40_components_syn.components.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity srom is
    port(        
        a : in  std_logic_vector (8 downto 0);   -- address
        t : in  std_logic;                       -- trigger (rising edge)
        o : out std_logic_vector (7 downto 0)); -- data
end entity srom;

-------------------------------------------------

architecture srom_arch of srom is

begin

    ram1 : SB_RAM512x8

        generic map (

            INIT_0 => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_1 => X"1111111111111111111111111111111111111111111111111111111111111111",
            INIT_2 => X"2222222222222222222222222222222222222222222222222222222222222222",
            INIT_3 => X"3333333333333333333333333333333333333333333333333333333333333333",
            INIT_4 => X"4444444444444444444444444444444444444444444444444444444444444444",
            INIT_5 => X"5555555555555555555555555555555555555555555555555555555555555555",
            INIT_6 => X"6666666666666666666666666666666666666666666666666666666666666666",
            INIT_7 => X"7777777777777777777777777777777777777777777777777777777777777777",

            INIT_8 => X"000102030405060708090A0B0C0D0E0F101112131415161718191A1B1C1D1E1F",
            INIT_9 => X"1F1E1D1C1B1A191817161514131211100F0E0D0C0B0A09080706050403020100",
            INIT_A => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_B => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_C => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_D => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_E => X"0000000000000000000000000000000000000000000000000000000000000000",
            INIT_F => X"0000000000000000000000000000000000000000000000000000000000000000")

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
