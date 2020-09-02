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

    -- signals

    signal clk : std_logic;         -- slower clock
    signal acc : std_logic_vector(8 downto 0);
    signal o   : std_logic_vector(7 downto 0);

begin

    -- instanciate clock divider

    clkdiv1 : clkdiv
        --generic map(10)              -- division by 1024
        generic map(2)                 -- division by 2
        port map(AlCu_CLOCK, clk);

    -- instanciate accumulator

    placc1_inst : placc
        generic map(9)
        port map('1', clk, "000000010", acc);

    -- instanciate srom

    srom1 : srom
        port map(acc, not clk, o);

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
