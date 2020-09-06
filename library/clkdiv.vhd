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
    generic (SIZE : integer := 8);  -- binary counter size
    port (i : in  std_logic;        -- input clock
          o : out std_logic);       -- output clock
end entity;

-------------------------------------------------

architecture clkdiv_arch of clkdiv is
    -- define counter
    signal c : std_logic_vector(SIZE-1 downto 0);
begin
    -- increment counter on input clock rising edge
    process (i)
    begin
        if rising_edge(i) then
            -- do conversions and increment counter
            c <= std_logic_vector(unsigned(c)+1);
        end if;
    end process;
    -- output clock value
    o <= c(SIZE-1);
-- done 
end architecture clkdiv_arch;
