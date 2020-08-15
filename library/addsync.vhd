-- ########################################################

-- file: addsync.vhd
-- content: full adder 1 bit size with sequential output
-- Created: 2020 august 14
-- Author: Roch Schanen
-- comments:
-- synchronous with the rising edge of trigger signal t
-- asynchronously cleared when reset signal r is low
-- with carry input and carry output logic

-- ########################################################

-- test synthesis using ghdl:
-- >ghdl -a addsync.vhd

-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------

entity addsync is
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
end entity addsync;

-------------------------------------------------

architecture addsync_arch of addsync is

    -- combinational signals
    signal ss, oo : std_logic;

begin
    
    -- combinational logic
    ss <= a XOR b XOR c;
    oo <= (a AND b) OR (a AND c) OR (b AND c);
    
    -- sequential logic
    process (r, t)
    begin

        -- asynchronous reset
        if r = '0' then
            s <= '0';
            o <= '0';

        -- synchronous sum and carry out
        elsif rising_edge(t) then
            s <= ss;
            o <= oo;

        end if;

    end process;

-- done    
end architecture addsync_arch;

-------------------------------------------------
