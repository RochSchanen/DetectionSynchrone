-- ########################################################

-- file: bench_srom.vhd
-- content: direct digital synthesis accumulator and rom test
-- Created: 2020 august 14
-- Author: Roch Schanen
-- comments: to compile and run see end note.

-- ########################################################


-------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity bench_srom is
end entity bench_srom;

-------------------------------------------------

architecture bench_arch of bench_srom is
    
    -- components

    component srom is
        generic (
            FN : string;
            AL : integer;
            DW : integer);
        port (
            a : in std_logic_vector (AL-1 downto 0);
            e : in std_logic;
            o : out std_logic_vector (DW-1 downto 0)  
        );
    end component srom;
    
    component placc
        generic (size : integer);
        port (
            r : in  std_logic;
            t : in  std_logic;
            a : out std_logic_vector(size-1 downto 0)
        );
    end component placc;
    
    -- constants

    -- clock
    constant tHP : time := 20 ns; -- half period
    constant tPD : time :=  5 ns; -- pulse duration

    -- rom file
    constant FN : string  := "SIN64x8.txt";
    -- rom length = 2**6 = 64
    constant AL : integer := 6;
    -- rom data width = 8 bits
    constant DW : integer := 8;

    -- signals

    -- rom enable
    signal re : std_logic := '0';
    -- rom address
    signal ra : std_logic_vector(AL-1 downto 0);
    -- rom data (value)
    signal rv : std_logic_vector(DW-1 downto 0);
    -- integrator reset (clear)
    signal clr  : std_logic := '0';
    -- integrator clock
    signal clk  : std_logic := '0';

begin

    -- connect rom
    rom_unit: srom
        generic map (FN, AL, DW)
        port map (ra, re, rv);
    
    -- connect integrator
    integrator_unit : placc
        generic map (AL)
        port map (clr, clk, ra);

    process
    begin

        -- init
        wait for 10 ns;
        clr <= '1';
        re  <= '1';
        wait for 10 ns;

        -- check two periods
        -- run 2*64+8 cycles
        -- (integrator latency is 8-1 cycles)
        clock: for n in 1 to 2*64+8 loop
            clk <= '1'; wait for tPD;
            clk <= '0'; wait for tHP-tPD;
        end loop clock;

    end process;
end architecture bench_arch;

-------------------------------------------------

-- note: ghdl compilation and vcd generation example.
-- move the bench file into the library folder
-- make a new work directory, compile, run and display.
-- >>> mkdir work
-- >>> ghdl -i --workdir=work *.vhd
-- >>> ghdl -m --ieee=synopsys --workdir=work bench_srom
--analyze bench_srom.vhd
--analyze srom.vhd
--analyze placc.vhd
--analyze fifobuf.vhd
--analyze addsync.vhd
--elaborate bench_srom
-- >>> ./bench_srom --vcd=ouput.vcd --stop-time=3us
--./bench_srom:info: simulation stopped by --stop-time @3us
-- >>> gtkwave ouput.vcd &
--
