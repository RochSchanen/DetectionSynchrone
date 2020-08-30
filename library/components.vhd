-- ########################################################

-- file: components.vhd
-- content: components package for detection synchrone
-- Created: 2020 august 29
-- Author: Roch Schanen
-- comments: ease the components declarations in top projects.
-- Use the following two lines to import all components definitions.
--
-- library work;
-- use work.components.all;

-- ########################################################

-------------------------------------------------
--            COMPONENTS DECLARATIONS
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

package components is

    -- clkdiv.vhd

    component clkdiv is
        generic (SIZE : integer := 8); -- binary counter size
        port(cli : in  std_logic;      -- input clock
             clo : out std_logic);     -- output clock
    end component;

    -- fifobuf.vhd

	component fifobuf is
    generic (size : integer := 0); -- buffer size
    port(r : in  std_logic; 	   -- reset (active low)
		 t : in  std_logic;        -- trigger (rising edge)
         i : in  std_logic;        -- data in
         o : out std_logic);       -- data out
	end component fifobuf;

	-- addsync.vhd

	component addsync is
	    port (r : in  std_logic;        -- reset (active low)
	          t : in  std_logic;        -- trigger (rising edge)
	          a, b, c : in  std_logic;  -- a, b and carry in
	          s, o    : out std_logic); -- sum and carry out
	end component addsync;

	component placc is
	    generic (size : integer := 4); -- accumulator size
	    port (r : in  std_logic;       -- reset (active low)
	          t : in  std_logic;       -- trigger (rising edge)
	          -- accumulator output value:
	          a : out std_logic_vector(size-1 downto 0));

	end component placc;

end package components;

-------------------------------------------------

