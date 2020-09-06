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
        port (i : in  std_logic;       -- input clock
              o : out std_logic);      -- output clock
    end component;

    -- fifobuf.vhd

    component fifobuf is
        generic (size : integer := 0); -- buffer size
        port (r : in  std_logic;       -- reset (active low)
              t : in  std_logic;       -- trigger (rising edge)
              i : in  std_logic;       -- data in
              o : out std_logic);      -- data out
    end component fifobuf;

    -- addsync.vhd

    component addsync is
        port (r : in  std_logic;        -- reset (active low)
              t : in  std_logic;        -- trigger (rising edge)
              a, b, c : in  std_logic;  -- a, b and carry in
              s, o    : out std_logic); -- sum and carry out
    end component addsync;

    -- placc.vhd

    component placc is
        generic (size : integer := 4); -- accumulator size
        port (r : in  std_logic;       -- reset (active low)
              t : in  std_logic;       -- trigger (rising edge)
              i : in  std_logic_vector(size-1 downto 0);  -- increment value
              o : out std_logic_vector(size-1 downto 0);  -- accumulator output
              c : out std_logic);                         -- overload (carry out)
    end component placc;

    -- plcnt.vhd

    component plcnt is
        generic (size : integer := 4); -- accumulator size
        port (r : in  std_logic;       -- reset (active low)
              t : in  std_logic;       -- trigger (rising edge)
              i : in  std_logic;       -- enable counter (carry in)
              o : out std_logic_vector(size-1 downto 0);
              c : out std_logic);      -- overload (carry out)
    end component plcnt;

    -- plnco.vhd

    component plnco is
        generic (
            accsize : integer := 4;  -- accumulator size
            cntsize : integer := 4); -- counter size
        port (r : in  std_logic;     -- reset (active low)
              t : in  std_logic;     -- trigger (rising edge)
              i : in std_logic_vector(accsize-1 downto 0);
              o : out std_logic_vector(cntsize+accsize-1 downto 0);
              c : out std_logic);    -- overload (carry out)
    end component plnco;

    -- srom.vhd

    component USIN102416 is
        port (a : in  std_logic_vector (9 downto 0);   -- address (10 bits)
              t : in  std_logic;                       -- trigger (rising edge)
              o : out std_logic_vector (16 downto 0)); -- data (16 bits)
    end component USIN102416;
    
    component uartr is
        port (t : in  std_logic;                      -- clock (rising edge)
              i : in  std_logic;                      -- data in
              v : out std_logic;                      -- validate
              o : out std_logic_vector (7 downto 0)); -- data out
    end component uartr;

end package components;

-------------------------------------------------
