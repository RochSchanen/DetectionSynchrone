-- ########################################################

-- file: AlchitryCu.vhd
-- content: testing AlchitryIo board
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

-------------------------------------------------

entity AlchitryCu is
    port(   AlIo_LED00 : out   std_logic;
            AlIo_BTN1  : inout std_ulogic;
            AlCu_CLOCK : in    std_logic);
end entity AlchitryCu;

-------------------------------------------------


-- test AlchitryIo board with ipd component

architecture arch of AlchitryCu is
    -- clock divider
    component clkdiv
        generic (   SIZE : integer := 16); -- frequency dividor
        port    (   cli  : in  std_logic;  -- input clock
                    clo  : out std_logic); -- output clock
    end component clkdiv;
    -- refresher
    component refresher
        port    (   cli : in  std_logic;  -- input clock
                    pld : out std_logic;  -- pull down signal
                    trg : out std_logic); -- trigger signal
    end component refresher;
    -- input with pull-down
    component ipd is
        port (  pld : in    std_logic;  -- pull-down enable
                trg : in    std_logic;  -- input trigger reading
                pin : inout std_ulogic; -- input pin name
                dat : out   std_logic); -- data available
    end component ipd;
    -- signals
    signal clk : std_logic; -- low frequency clock
    signal pld : std_logic; -- pull-down signal
    signal trg : std_logic; -- trigger signal
begin
    -- instanciate clock divider
    clkdiv_inst : clkdiv
        generic map(4)                      -- division by 16
        port map(AlCu_CLOCK, clk);
    -- instanciate refresher
    refresher_inst : refresher
        port map (clk, pld, trg);
    -- instanciate ipd
    pid_inst : ipd
        port map (pld, trg, AlIo_BTN1, AlIo_LED00);
-- done
end architecture arch;





-------------------------------------------------
--                  IPD
-------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library sb_ice40_components_syn;
use sb_ice40_components_syn.components.all;

-------------------------------------------------

-- input with pull-down

entity ipd is
    port (  pld : in    std_logic;    -- pull-down enable
            trg : in    std_logic;    -- input trigger reading
            pin : inout std_ulogic;   -- input pin name
            dat : out   std_logic);   -- data available
end entity ipd;

-------------------------------------------------

architecture ipd_arch of ipd is

    signal din : std_logic;

    begin

    -- output configuration is defined as follow:
    -- use OUTPUT_ENABLE asynchronously : bit 5, 4 => 1, 0
    -- PACKAGE_PIN is a copy of D_OUT_0 : bit 3, 2 => 1, 0
    -- D_IN_0 is a copy of PACKAGE_PIN  : bit 1, 0 => 0, 1
    -- configuration string is thus "101001"
    -- see note in "ICE40_HX8K_CB132_primitives_SB_IO.txt"
    -- no comment means unused port/signal

    sb_io_inst : SB_IO

        generic map (
            NEG_TRIGGER => '0',
            PIN_TYPE    => "101001",
            PULLUP      => '0',
            IO_STANDARD => "SB_LVCMOS"
        )
        
        port map (
            D_OUT_1           => '0',   -- 
            D_OUT_0           => '0',   -- pull-down : output value is 0
            CLOCK_ENABLE      => '0',   -- 
            LATCH_INPUT_VALUE => '0',   -- 
            INPUT_CLK         => '0',   -- 
            D_IN_1            => open,  -- 
            D_IN_0            => din,   -- data input (copy of PACKAGE_PIN)
            OUTPUT_ENABLE     => pld,   -- pull-down : enable ouput signal
            OUTPUT_CLK        => '0',   -- 
            PACKAGE_PIN       => pin    -- io port name (as in .pcf file)
        ); 
 
    process (trg)
    begin
        if rising_edge(trg) then
            dat <= din;
        end if;
    end process;

end architecture ipd_arch;

-- note to self: should use the io bit register on the io port instead
-- of using an extra dff.

-------------------------------------------------



-------------------------------------------------
--                 REFRESHER
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library sb_ice40_components_syn;
use sb_ice40_components_syn.components.all;

entity refresher is
    port (  cli : in  std_logic;    -- input clock
            pld : out std_logic;    -- pull down signal
            trg : out std_logic);   -- trigger signal
end entity refresher;

-------------------------------------------------

architecture refresher_arch of refresher is
    signal cnt : std_logic_vector(3 downto 0) :=  (others => '0');
begin
    LUT1 : SB_LUT4 -- pull down signal : stray capacitance discharge
        generic map("0000000011111111") -- Least Significant Bit First Out
        port map (pld, cnt(0), cnt(1), cnt(2), cnt(3));
    LUT2 : SB_LUT4 -- trigger signal : record input status before recharge
        generic map("0000001000000000") -- Least Significant Bit First Out
        port map (trg, cnt(0), cnt(1), cnt(2), cnt(3));
    process (cli) 
    begin -- increment counter on rising edge of the clock
        if rising_edge(cli) then
            cnt <= std_logic_vector(unsigned(cnt)+1);
        end if;
    end process;
-- done
end architecture refresher_arch;

-- note for self:
--
-- the optimum setup for the signals depends on the time
-- contants involves in the charge an discharge of the stray
-- capacitors. there are four cases to consider:
-- 1. output on high impedance with swicth level high.
-- 2. output on high impedance with swicth level floating.
-- 3. output pulled-down with swicth level high.
-- 4. output pulled-down with swicth level floating.
-- The time constants to consider are the time to reach equilibrium
-- during the transition between these cases.
--
-- Case 2 is the case that should have been avoided by the design
-- of AlchitryIo and that causes the issue since the FPGA of AlchitryCu
-- down not have a pull-down configuration for its io ports. Only
-- the pull-up configuration option is available. The switches
-- hard wiring should have had the signal simply floating or
-- simply grounded: this configuration also allows to have several
-- concurrent sources connected to the same pin.

-------------------------------------------------





-------------------------------------------------
--                  CLKDIV
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- divides the input clock by a power of two
-- using a binary counter of abrbitray size

-------------------------------------------------

entity clkdiv is
    generic (
        -- size of the binary counter
        -- default is divison by 65536
        SIZE : integer := 16
    );
    port(
        -- input clock
        cli : in std_logic;
        -- output clock
        clo : out std_logic
    );
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

