-- ########################################################

-- file: placc.vhd
-- content: pipelined accumulator of arbitrary size
-- Created: 2020 august 14
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- generic size has been tested for integers larger than 4

-- ########################################################

-- test synthesis using ghdl:
-- >ghdl -a placc.vhd

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

library work;
use work.components.all;

-------------------------------------------------

entity placc is
    generic (size : integer := 4); -- accumulator size
    port (r : in  std_logic;       -- reset (active low)
          t : in  std_logic;       -- trigger (rising edge)
          -- accumulator output value:
          a : out std_logic_vector(size-1 downto 0));
end entity placc;

-------------------------------------------------

architecture placc_arch of placc is

    -- signals
    signal cc : std_logic_vector(size   downto 0); -- carry lines
    signal ii : std_logic_vector(size-1 downto 0); -- adders input
    signal oo : std_logic_vector(size-1 downto 0); -- adders ouput

    -- accumulator increment                                        !!! move to input
    signal ss : std_logic_vector(size-1 downto 0):=
        (0 => '1', 1 => '0', others => '0');

begin

    -- integrator carry in is always zero
    cc(0) <= '0';

    -- for each data bit: 
    
    --   one input pipeline
    --   one adder
    --   one output pipeline

    NETWORK : for n in 0 to size-1 generate

        ipl : fifobuf
            generic map (n)
            port map (r, t, ss(n), ii(n));

        add : addsync
            port map (r, t, ii(n), oo(n), cc(n), oo(n), cc(n+1));

        opl : fifobuf
            generic map (size-n)
            port map (r, t, oo(n), a(n));

    end generate NETWORK;

end architecture placc_arch;

-------------------------------------------------
