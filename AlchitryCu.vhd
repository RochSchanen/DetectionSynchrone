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
    port(AlBr_IO_08 : out   std_logic;  -- Bank B 48
         AlBr_IO_09 : out   std_logic;  -- Bank B 45
         AlBr_IO_10 : out   std_logic;  -- Bank B 42
         AlBr_IO_11 : out   std_logic;  -- Bank B 39
         AlBr_IO_12 : out   std_logic;  -- Bank B 36
         AlBr_IO_13 : out   std_logic;  -- Bank B 33
         AlBr_IO_14 : out   std_logic;  -- Bank B 30
         AlBr_IO_15 : out   std_logic;  -- Bank B 27
         AlBr_IO_32 : out   std_logic;  -- Bank B 2
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

    constant ACCSIZE : integer := 9;
    constant CNTSIZE : integer := 5;

    -- signals

    signal clk : std_logic;
    signal acc : std_logic_vector(CNTSIZE-1+ACCSIZE downto 0);
    signal o   : std_logic_vector(15 downto 0);
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
        port map('1', clk, "000001000", acc, c);

    -- instanciate srom
    srom1 : USIN102416
        port map(acc(CNTSIZE-1+ACCSIZE downto 4), clk, o);

    ---- output value
    AlBr_IO_08 <= o(15);
    AlBr_IO_09 <= o(14);
    AlBr_IO_10 <= o(13);
    AlBr_IO_11 <= o(12);
    AlBr_IO_12 <= o(11);
    AlBr_IO_13 <= o(10);
    AlBr_IO_14 <= o(09);
    AlBr_IO_15 <= o(08);

    AlBr_IO_32 <= o(07);
    AlBr_IO_33 <= o(06);
    AlBr_IO_34 <= o(05);
    AlBr_IO_35 <= o(04);

    -- PM7545 DAC resolution is 12 bits
    -- cut-off here at 12 bits (no rounding)

    --AlBr_IO_36 <= o(03);
    --AlBr_IO_37 <= o(02);
    --AlBr_IO_38 <= o(01);
    --AlBr_IO_39 <= o(00);
 
-- done
end architecture arch;

-------------------------------------------------
