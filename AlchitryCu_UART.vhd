library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity AlchitryCu_UART is
	port(
		AlCu_CLOCK : in  std_logic;		-- clock 100MHz
		AlCu_LED_0 : out std_logic; 	-- output LED
		AlCu_LED_1 : out std_logic; 	-- output LED
		AlCu_UART_RX : in  std_logic;	-- UART read
		AlCu_UART_TX : out std_logic  	-- UART transmit
	);
end entity AlchitryCu_UART;

architecture AlchitryCu_UART_arch of AlchitryCu_UART is

	-- counter
	signal counter : std_logic_vector(25 downto 0);

	begin

	-- connect RX to TX
	-- this echo any input straight to the output
	-- useful for testing USB port communication
	AlCu_UART_TX <= AlCu_UART_RX;

	-- connect the transmit signal to a LED for checking transmission
	AlCu_LED_1 <= AlCu_UART_RX;

	-- we keep the blink part to check the clock
	-- both part are independent

	-- increment on clock rising edge
	process (AlCu_CLOCK)
	begin
		if rising_edge(AlCu_CLOCK) then
			-- conversions and increment counter
			counter <= std_logic_vector(unsigned(counter)+1);
		end if;
	end process;

	-- output most significant bit of the counter
	AlCu_LED_0 <= counter(25);
	
	-- done
end architecture AlchitryCu_UART_arch;
