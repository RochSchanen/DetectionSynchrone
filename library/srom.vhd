-- ########################################################

-- file: srom.vhd
-- content: simulated read only memory
-- Created: 2020 august 14
-- Author: Roch Schanen
-- comments:
-- data loaded from a file at initialisation.
-- output data are applied when output enabled is high.
-- otherwise the output lines remain at high impedance.
-- the data file contains (2**AL) lines.
-- one line contains DW bits.

-- ########################################################

-- test synthesis using ghdl:
-- >ghdl -a --ieee=synopsys srom.vhd

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_textio.all;
use ieee.numeric_std.all;
use STD.textio.all;

-------------------------------------------------

entity srom is
    
    -- rom geometry
    generic (
    
        -- file name
        FN : string  := "SIN256x8.txt";
    
        -- address length
        AL : integer := 8;
    
        -- data width
        DW : integer := 8);

    port (
        -- address
        a : in std_logic_vector (AL-1 downto 0);
    
        -- output enable
        e : in std_logic;
    
        -- data out
        o : out std_logic_vector (DW-1 downto 0)  
    );
end entity srom;

-------------------------------------------------

architecture srom_arch of srom is

    -- define geometry
    type CORE is array (0 to 2**AL-1) 
        of std_logic_vector(DW-1 downto 0);

    -- init rom from file function
    impure function initRom(f: in string) return CORE is 

        -- local variables
        file     h : text is in f;
        variable l : line;
        variable c : CORE;

    begin

        -- load data from each lines
        for i in 0 to 2**AL-1 loop
            readline (h, l);  -- get string
            read (l, c(i));   -- convert to data
        end loop;

        -- data ready
        return c;
    
    end function initRom;
    
    -- instantiate rom using init function
    constant c : CORE := initRom(FN);

begin

    -- sequential logic
    process (a, e)
    begin

        -- enable output
        if e = '1' then

            -- load data
            o <= c(to_integer(unsigned(a)));

        -- high impedance output
        else
            o <= (others => 'Z');

        end if;

    end process;

--done
end architecture srom_arch;
