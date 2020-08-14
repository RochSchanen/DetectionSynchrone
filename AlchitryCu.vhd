library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AlchitryCu is
    port(
        -- clock 100MHz
        AlCu_CLOCK : in  std_logic;
        -- accumulator output
        AlCu_IO0 : out std_logic;
        AlCu_IO1 : out std_logic;
        AlCu_IO2 : out std_logic;
        AlCu_IO3 : out std_logic;
        AlCu_IO4 : out std_logic;
        AlCu_IO5 : out std_logic;
        AlCu_IO6 : out std_logic;
        AlCu_IO7 : out std_logic
   );
end entity AlchitryCu;

architecture AlchitryCu_arch of AlchitryCu is
    
    -- constant
    constant S : integer := 8; -- accumulator width

    -- components
    component Integrator
        generic (size : integer);
        port (
            r : in std_logic; -- reset
            t : in std_logic; -- clock
            a : out std_logic_vector(size-1 downto 0)
        );
    end component Integrator;
    
    -- signals
    signal o : std_logic_vector(S-1 downto 0);
    
    begin

    -- instanciate accumulator
    ACU : Integrator
        generic map(S)
        port map ('1', AlCu_CLOCK, o);

    -- output network
    AlCu_IO0 <= o(0);
    AlCu_IO1 <= o(1);
    AlCu_IO2 <= o(2);
    AlCu_IO3 <= o(3);
    AlCu_IO4 <= o(4);
    AlCu_IO5 <= o(5);
    AlCu_IO6 <= o(6);
    AlCu_IO7 <= o(7);

-- done
end architecture AlchitryCu_arch;
