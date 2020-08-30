-- ########################################################

-- file: clkdiv.vhd
-- content: clock divider by a power of 2
-- Created: 2020 august 29
-- Author: Roch Schanen
-- comments: no reset

-- ########################################################

-------------------------------------------------
--                  CLKDIV
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity clkdiv is
    generic (SIZE : integer := 8); -- binary counter size
    port(cli : in  std_logic;      -- input clock
         clo : out std_logic);     -- output clock
end entity;

-------------------------------------------------

architecture clkdiv_arch of clkdiv is
    -- define counter
    signal counter : std_logic_vector(SIZE-1 downto 0);
begin
    -- increment counter on input clock rising edge
    process (cli)
    begin
        if rising_edge(cli) then
            -- do conversions and increment counter
            counter <= std_logic_vector(unsigned(counter)+1);
        end if;
    end process;
    -- output clock value
    clo <= counter(SIZE-1);
-- done 
end architecture clkdiv_arch;
