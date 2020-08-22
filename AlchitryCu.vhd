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
    port(
        AlBr_IO0 : out std_logic;
        AlBr_IO1 : out std_logic;
        AlBr_IO2 : out std_logic;
        AlCu_CLOCK : in std_logic
   );
end entity AlchitryCu;

-------------------------------------------------

architecture arch of AlchitryCu is

    -- declare components

    component clkdiv
        generic (
            SIZE : integer := 16
        );
        port(
            cli : in std_logic; 
            clo : out std_logic
        );
    end component clkdiv;

    component refresher
        port (
            cli      : in  std_logic;
            pulldown : out std_logic;
            trigger  : out std_logic
        );
    end component refresher;

    -- declare signals

    signal clk : std_logic;

begin

    -- instanciate components

    clkdiv_inst : clkdiv
        generic map(4)
        port map(AlCu_CLOCK, clk);

    refresher_inst : refresher
        port map (clk, AlBr_IO1, AlBr_IO2);

    AlBr_IO0 <= clk;

-- done
end architecture arch;





-------------------------------------------------
--                 REFRESHER
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity refresher is
    port (
        -- input clock
        cli : in  std_logic;
        -- outputs
        pulldown : out std_logic;
        trigger  : out std_logic
    );
end entity refresher;

-------------------------------------------------

architecture refresher_arch of refresher is
    -- pull-down sequence
    constant pld : std_logic_vector (0 to 15) := "0000000011111111";
    -- trigger sequence
    constant trg : std_logic_vector (0 to 15) := "0000000000011000";
    -- initialise counter
    signal counter : std_logic_vector(3 downto 0);
begin
    process (cli)
    begin
        -- increment counter pointer on falling edge of clock
        if falling_edge(cli) then
            counter <= std_logic_vector(unsigned(counter)+1);
        end if;
        -- validate waveform data on falling edge of clock
        if rising_edge(cli) then
            pulldown <= pld(to_integer(unsigned(counter)));
            trigger  <= trg(to_integer(unsigned(counter)));
        end if;
    end process;
-- done
end architecture refresher_arch;





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














-------------------------------------------------
--                  TEMP
-------------------------------------------------


--library sb_ice40_components_syn;
--use sb_ice40_components_syn.components.all;

-------------------------------------------------

    --myoutput : SB_IO

    --    generic map (
    --        NEG_TRIGGER     => '0',
    --        PIN_TYPE        => "011001",
    --        PULLUP          => '0',
    --        IO_STANDARD     => "SB_LVCMOS"
    --    )
        
    --    port map (
    --        D_OUT_1             => '0',
    --        D_OUT_0             => counter(24),
    --        CLOCK_ENABLE        => '0',
    --        LATCH_INPUT_VALUE   => '0',
    --        INPUT_CLK           => AlCu_CLOCK, 
    --        D_IN_1              => open,
    --        D_IN_0              => open,
    --        OUTPUT_ENABLE       => '0',
    --        OUTPUT_CLK          => '0',
    --        PACKAGE_PIN         => AlIo_LED01
    --    ); 
