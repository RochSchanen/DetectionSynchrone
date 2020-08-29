-- ########################################################

-- file: AlchitryCu.vhd
-- content: testing AlchitryIo board
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

-------------------------------------------------

entity AlchitryCu is
    port(   AlIo_LED00 : out   std_logic;
            AlIo_BTN1  : inout std_ulogic;
            AlCu_CLOCK : in    std_logic);
end entity AlchitryCu;

-------------------------------------------------


-- test AlchitryIo board with ipd component

architecture arch of AlchitryCu is
    -- clock divider
    component clkdiv
        generic (   SIZE : integer := 16); -- frequency dividor
        port    (   cli  : in  std_logic;  -- input clock
                    clo  : out std_logic); -- output clock
    end component clkdiv;
    -- refresher
    component refresher
        port    (   cli : in  std_logic;  -- input clock
                    pld : out std_logic;  -- pull down signal
                    trg : out std_logic); -- trigger signal
    end component refresher;
    -- input with pull-down
    component ipd is
        port (  pld : in    std_logic;  -- pull-down enable
                trg : in    std_logic;  -- input trigger reading
                pin : inout std_ulogic; -- input pin name
                dat : out   std_logic); -- data available
    end component ipd;
    -- signals
    signal clk : std_logic; -- low frequency clock
    signal pld : std_logic; -- pull-down signal
    signal trg : std_logic; -- trigger signal
begin
    -- instanciate clock divider
    clkdiv_inst : clkdiv
        generic map(4)                      -- division by 16
        port map(AlCu_CLOCK, clk);
    -- instanciate refresher
    refresher_inst : refresher
        port map (clk, pld, trg);
    -- instanciate ipd
    pid_inst : ipd
        port map (pld, trg, AlIo_BTN1, AlIo_LED00);
-- done
end architecture arch;






