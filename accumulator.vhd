-- accumulator.vhd
-- content: "An accumulator home designed targeted
-- for maximum speed using a pipeline processs to
-- generate one set of data per clock cycle"
-- Created: 2020 july 7
-- Author: Roch Schanen
-- comment: "RTL tested on a bench using GHDL.
-- the integrator consiste of 3 components:
-- 1) A single bit data full adder (FA) called 'adder'
-- 2) An arbitraty length pipeline build on a
-- single bit FIFO buffer called 'pipe'
-- 3) An arbitrary length accumulator called
-- 'integrator' which architecture is directly
-- described by its internal connections networks.
-- This particular design allows for the variable
-- length of the accumulator."

--###############################################

-- full adder 1bit
-- synced with rising edge trigger
-- and cleared with asynchronous reset
-- (separately bench tested)

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity adder is
    port (
        -- clear (reset) active low
        r : in  std_logic;
        -- clock (trigger) rising edge
        t : in  std_logic;
        -- data inputs (a, b and carry)
        a, b, c : in  std_logic;
        -- data outputs (sum and carry)
        s, o    : out std_logic
    );
end entity adder;

-------------------------------------------------

architecture adder_arch of adder is
    -- intermediate signals
    signal ss, oo : std_logic;
begin
    -- adder
    ss <= a XOR b XOR c;
    oo <= (a AND b) OR (a AND c) OR (b AND c);
    -- sequence
    process (r, t)
    begin
        if r = '0' then
            s <= '0';
            o <= '0';
        elsif rising_edge(t) then
            s <= ss;
            o <= oo;
        end if;
    end process;
end architecture adder_arch;


--###############################################

-- first-in first-out pipe of generic size
-- synced with rising edge trigger
-- and cleared with asynchronous reset
-- generic size is any positive integer
-- zero means that the pipe is a single wire
-- one means that the pipe is a single flip-flop
-- N means a linked chain of N flip-flops
-- (separately bench tested)

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity pipe is
    -- default size generates a single wire
    generic (size : integer:= 0);
    port(
        -- clear (reset) active low
        r : in  std_logic;
        -- clock (trigger) rising edge
        t : in  std_logic;
        -- data inputs (bit in)
        i : in  std_logic;
        -- data outputs (bit out)
        o : out std_logic
    );
end entity pipe;

-------------------------------------------------

architecture pipe_arch of pipe is
begin
    -- extend the case N = 0
    -- in this case, create a
    -- direct input to output link
    NOGATE : if size = 0 generate
    begin
        -- direct link
        o <= i;
    end generate NOGATE;
    -- in the other cases at least one
    -- flip flop is generated and a
    -- minimum delay of one cycle is
    -- obtained.
    NGATES : if size > 0 generate
        signal bf:
            std_logic_vector(size-1 downto 0);
                -- start with unknown 'U' for debugging:
                --:= (others => 'U');
                -- start with low level '0' for debugging:
                --:= (others => '0');
                -- for synthesis, don't initialise
    begin
        -- output msb
        o <= bf(size-1);
        -- process trigger/clear
        process(r, t)
        begin
            -- reset
            if r = '0' then
                -- clear buffer
                bf <= (others => '0');
            -- trigger
            elsif rising_edge(t) then
                -- shift
                for n in size-1 downto 1 loop
                    bf(n) <= bf(n-1);
                end loop;
                -- load lsb
                bf(0) <= i;
            end if;
        end process;
    end generate NGATES;
end architecture pipe_arch;

--###############################################

-- integrator of generic size
-- synced with rising edge trigger
-- and cleared with asynchronous reset
-- generic size is any positive integer
-- (being tested)

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity Integrator is
    generic (size : integer);
    port (
        -- clear (reset) active low
        r : in  std_logic;
        -- clock (trigger) rising edge
        t : in  std_logic;
        -- data output (accumulator)
        a : out std_logic_vector(size-1 downto 0)
    );
end entity Integrator;

-------------------------------------------------

architecture Integrator_arch of Integrator is
    -- use adders
    component adder
        port (r,t,a,b,c:in std_logic; s,o:out std_logic);
    end component adder;
    -- use pipes
    component pipe
        generic (size:integer);
        port(r,t,i:in std_logic; o:out std_logic);
    end component pipe;
    -- signals
    signal cc : std_logic_vector(size   downto 0);      -- carry lines
    signal ii : std_logic_vector(size-1 downto 0);      -- adders input
    signal oo : std_logic_vector(size-1 downto 0);      -- adders ouput
    signal ss : std_logic_vector(size-1 downto 0):=(    -- increment bits
        0 => '1',
        1 => '1',
        2 => '0',
        3 => '0',
        others => '0'); -- integrator increment for tests (currently = 3)
begin
    -- integrator carry in is always zero
    cc(0) <= '0';
    -- for each data bit:
    -- make two pipeline
    -- make one adder
    NETWORK : for n in 0 to size-1 generate
        inputPipelines : pipe
            generic map (n) -- pipeline length
            port    map (
                r,      -- reset (asynchronous)
                t,      -- trigger (clock)
                ss(n),  -- increment bit n
                ii(n)   -- to adder input
            );
        adders : adder
            port map (
                r,      -- reset (asynchronous)
                t,      -- trigger (clock)
                ii(n),  -- from input pipeline bit n
                oo(n),  -- from adder output bit n
                cc(n),  -- carry from previous adder
                oo(n),  -- adder output bit n
                cc(n+1) -- carry to next adder
            );
        outputPipelines : pipe
            generic map (size-n) -- pipeline length
            port map (
                r,      -- reset (asynchronous)
                t,      -- trigger (clock)
                oo(n),  -- from adder output bit n
                a(n)    -- to integrator output bit n
            );
    end generate NETWORK;
end architecture Integrator_arch;
