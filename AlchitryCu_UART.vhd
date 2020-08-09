library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity AlchitryCu_UART is
	port(
		AlCu_CLOCK : in  std_logic;		-- clock 100MHz
		AlCu_LED_0 : out std_logic; 	-- output LED
		AlCu_LED_1 : out std_logic; 	-- output LED
		AlCu_LED_2 : out std_logic; 	-- output LED
		AlCu_LED_3 : out std_logic; 	-- output LED
		AlCu_LED_4 : out std_logic; 	-- output LED
		AlCu_LED_5 : out std_logic; 	-- output LED
		AlCu_LED_6 : out std_logic; 	-- output LED
		AlCu_LED_7 : out std_logic; 	-- output LED
		AlCu_UART_RX : in  std_logic;	-- UART read
		AlCu_UART_TX : out std_logic  	-- UART transmit
	);
end entity AlchitryCu_UART;

-- todo:
-- todo: maybe only clear the MSB of the counter
-- todo:

architecture AlchitryCu_UART_arch of AlchitryCu_UART is

	-- Finite State Machine Declarations
	-- (tState is the states types : enumerated)
	-- (vState is the state value, default is "sReady")
	type   tState is (sReady, sStart, sReceive, sStop, sValidate);
	signal vState : tState := sReady;

	-- data registers
	signal data : std_logic_vector (7 downto 0) := (others => '0');
	signal btpt : integer range 0 to 7 := 0; -- bit pointer
	--signal dval : std_logic := '0'; -- data validate

	-- counter 
	-- (128 cycles is one UART pulse width: check bit 7)
	-- (64 cycles is half a UART pulse width: check bit 6)
	-- serial port baud rate must be set at 781250 bit/s
	-- This gives 781250*128 = 100 000 000 Hz = clock freq.
	signal cntr : std_logic_vector(7 downto 0);

	begin

		-- echo received data to transmit data for test
		AlCu_UART_TX <= AlCu_UART_RX;

		pUART : process (AlCu_CLOCK)

			begin

				-- update at rising edges of the clock
				if rising_edge (AlCu_CLOCK) then

					case vState is
					

						-- READY
						-------------------------------------------------------
						-- the machine starts in the waiting state "Ready"
						-- it waits for the received level to go low

						when sReady =>

							-- level is low: the machine goes into the "Start" state
							if AlCu_UART_RX = '0' then

								-- go to the "Start" state
								vState <= sStart;
							
							-- level is high: keeps the machine in the waiting state
							else

								-- keep the machine in the "Ready" state
								vState <= sReady;

							end if;
							
							-- in all circumstances, counter and
							-- bit pointer a set to zero:
							
							-- clear counter
							cntr <= (others => '0');

							-- clear data validate
							--dval <= '0';

							-- clear bit pointer (is this in the correct place?)                 !
							btpt <= 0; 				 
				


						-- START
						-------------------------------------------------------
						-- wait for half a period and confirm the low level value
						
						when sStart =>
							
							-- check if half period is reached (bit 6 == 64 clock cycles)
							if cntr(6) = '1' then
								
								-- check "Receive" level
								if AlCu_UART_RX = '0' then
									
									-- clear counter
									cntr <= (others => '0');

									-- go to the "Receive" state
									vState <= sReceive;

								-- clear bit pointer (is this in the correct place?)             !
								--btpt <= 0; 
								
								else
									-- if the level is high, assume that the initial
									-- low level value was a spurious signal. go back
									-- to the "Ready" state.
									vState <= sReady;
								
								end if;

							-- wait until half period
							else
								
								-- increment counter
								cntr <= std_logic_vector(unsigned(cntr)+1);
								
								-- keep the machine in the "Start" state 
								vState <= sStart;
							
							end if;


						-- RECEIVE
						-------------------------------------------------------
						-- wait for a full period and read the data level
						
						when sReceive =>
							
							-- check if a full period is reached (bit 7 == 128 clock cycles)
							if cntr(7) = '1' then
								
								-- clear counter
								cntr <= (others => '0'); 

								-- record the "Receive" value and increase bit pointer
								data(btpt) <= AlCu_UART_RX;
								
								-- last data bit
								if btpt = 7 then

									-- clear bit pointer (is this in the correct place?)         !
									btpt <= 0;
									
									-- go to "Stop" state
									vState <= sStop;

								-- not the last data bit
								else

									-- increment bit pointer
									btpt <= btpt + 1;

									-- continue in "Receive" state
									vState <= sReceive;

								end if;

							-- continue with increasing the counter
							else

								-- increment counter
								cntr <= std_logic_vector(unsigned(cntr)+1);

								-- continue in "Receive" state
								vState <= sReceive;

							end if;


						-- STOP
						-------------------------------------------------------
						-- wait for another full period and set the validate signal

						when sStop =>

							if cntr(7) = '1' then

								-- clear counter
								cntr <= (others => '0'); 

								-- set validate signal
								--dval <= '1';

								-- go to "Validate" state
								vState <= sValidate;

							else

								-- increment counter
								cntr <= std_logic_vector(unsigned(cntr)+1);

								-- continue in "Stop" state
								vState <= sStop;

							end if;


						-- VALIDATE
						-------------------------------------------------------
						-- the validate pulse last for only one AlCu_CLOCK cycle.
						-- it is triggered at the middle of the UART stop pulse.
						-- it is ended in the "Validate" state immediately.

						when sValidate =>

							-- clear validate
							--dval <= '0';

							-- go to "Ready" state
							vState <= sReady;


						-- OTHERS
						-------------------------------------------------------
						-- all other cases

						when others =>

							-- in any other case, go back to the "Ready" state
							vState <= sReady;


					-- done
					end case;

				-- end AlCu_CLOCK rising_edge event
				end if;

		-- todo: set the leds


		end process pUART;

	AlCu_LED_0 <= data(0);
	AlCu_LED_1 <= data(1);
	AlCu_LED_2 <= data(2);
	AlCu_LED_3 <= data(3);
	AlCu_LED_4 <= data(4);
	AlCu_LED_5 <= data(5);
	AlCu_LED_6 <= data(6);
	AlCu_LED_7 <= data(7);

-- done
end architecture AlchitryCu_UART_arch;
