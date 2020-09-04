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
    port(AlBr_IO_08 : out   std_logic;  -- Bank B 2
         AlBr_IO_09 : out   std_logic;  -- Bank B 5
         AlBr_IO_10 : out   std_logic;  -- Bank B 8
         AlBr_IO_11 : out   std_logic;  -- Bank B 11
         AlBr_IO_12 : out   std_logic;  -- Bank B 14
         AlBr_IO_13 : out   std_logic;  -- Bank B 17
         AlBr_IO_14 : out   std_logic;  -- Bank B 20
         AlBr_IO_15 : out   std_logic;  -- Bank B 23
         AlBr_IO_32 : out   std_logic;  -- Bank B 23
         AlBr_IO_33 : out   std_logic;  -- Bank B 23
         AlBr_IO_34 : out   std_logic;  -- Bank B 23
         AlBr_IO_35 : out   std_logic;  -- Bank B 23
         AlBr_IO_36 : out   std_logic;  -- Bank B 23
         AlBr_IO_37 : out   std_logic;  -- Bank B 23
         AlBr_IO_38 : out   std_logic;  -- Bank B 23
         AlBr_IO_39 : out   std_logic;  -- Bank B 23
         AlCu_CLOCK : in    std_logic); -- 100MHz clock
end entity AlchitryCu;

-------------------------------------------------

architecture arch of AlchitryCu is

    constant ACCSIZE : integer := 4;
    constant CNTSIZE : integer := 9;

    -- signals

    signal clk : std_logic;
    signal acc : std_logic_vector(CNTSIZE-1+ACCSIZE downto 0);
    signal o   : std_logic_vector(7 downto 0);
    signal c   : std_logic;

begin

    -- instanciate clock divider

    clkdiv1 : clkdiv
        generic map(5)             -- division by 1024
        --generic map(2)             -- division by 2
        port map(AlCu_CLOCK, clk);

    -- instanciate accumulator

    plnco1 : plnco
        generic map(ACCSIZE, CNTSIZE)
        port map('1', clk, "0001", acc, c);

    -- instanciate srom

    srom1 : srom
        port map(acc(CNTSIZE-1+ACCSIZE downto ACCSIZE), not clk, o);

    ---- output value

    AlBr_IO_08 <= o(7);
    AlBr_IO_09 <= o(6);
    AlBr_IO_10 <= o(5);
    AlBr_IO_11 <= o(4);
    AlBr_IO_12 <= o(3);
    AlBr_IO_13 <= o(2);
    AlBr_IO_14 <= o(1);
    AlBr_IO_15 <= o(0);

    AlBr_IO_32 <= clk;
 
-- done
end architecture arch;

-------------------------------------------------
