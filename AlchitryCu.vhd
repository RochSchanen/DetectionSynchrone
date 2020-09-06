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
    port(AlCu_LED_0   : out std_logic;
         AlCu_LED_1   : out std_logic;
         AlCu_LED_2   : out std_logic;
         AlCu_LED_3   : out std_logic;
         AlCu_LED_4   : out std_logic;
         AlCu_LED_5   : out std_logic;
         AlCu_LED_6   : out std_logic;
         AlCu_LED_7   : out std_logic;
         AlCu_UART_TX : out std_logic;
         AlCu_UART_RX : in  std_logic;
         AlCu_CLOCK   : in  std_logic);
end entity AlchitryCu;

-------------------------------------------------

architecture arch of AlchitryCu is

    signal d : std_logic_vector (7 downto 0);

begin

    -- return serial input
    AlCu_UART_TX <= AlCu_UART_RX;

    -- instanciate uartr
    uartr1 : uartr
        port map(AlCu_CLOCK, AlCu_UART_RX, open, d);

    AlCu_LED_0 <= d(0);
    AlCu_LED_1 <= d(1);
    AlCu_LED_2 <= d(2);
    AlCu_LED_3 <= d(3);
    AlCu_LED_4 <= d(4);
    AlCu_LED_5 <= d(5);
    AlCu_LED_6 <= d(6);
    AlCu_LED_7 <= d(7);
 
-- done
end architecture arch;

-------------------------------------------------
