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
use work.components.clkdiv;

-------------------------------------------------

entity AlchitryCu is
    port(   AlCu_LED_0 : out   std_logic;
            AlCu_CLOCK : in    std_logic);
end entity AlchitryCu;

-------------------------------------------------

architecture arch of AlchitryCu is

    -- signals
    signal clk : std_logic;                -- slow clock

begin

    -- instanciate clock divider 1
    clkdiv1 : clkdiv
        generic map(4)                     -- division by 4
        port map(AlCu_CLOCK, clk);

    -- instanciate clock divider 2
    clkdiv2 : clkdiv
        generic map(20)                    -- division by 22
        port map(clk, AlCu_LED_0);

-- done
end architecture arch;

-------------------------------------------------
