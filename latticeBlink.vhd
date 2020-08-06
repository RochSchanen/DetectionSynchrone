library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity latticeBlink is
	port(
		clk : in  std_logic;	-- clock 100MHz
		led : out std_logic 	-- output LED
	);
end entity latticeBlink;

architecture latticeBlink_arch of latticeBlink is
	-- counter
	signal counter : std_logic_vector(25 downto 0);
	begin
	-- increment on clock rising edge
	process (clk)
	begin
		if rising_edge(clk) then
			-- conversions and increment counter
			counter <= std_logic_vector(unsigned(counter)+1);
		end if;
	end process;
	-- output most significant bit of the counter
	led <= counter(25);
	-- done
end architecture latticeBlink_arch;
