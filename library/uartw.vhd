-- ########################################################

-- file: uartw.vhd
-- content: UART write (FPGA sending data)
-- Created: 2020 september 08
-- Author: Roch Schanen
-- comments:

-- ########################################################





-------------------------------------------------
--                   UARTW
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity uartw is
    port (t : in  std_logic;                      -- clock (rising edge)
          i : in  std_logic_vector (7 downto 0);  -- data in (one byte)
          l : in  std_logic;                      -- load (rising edge)
          o : out std_logic);                     -- data out (serial)
end entity uartw;

-------------------------------------------------

-- NOTE TO DO: maybe only clear the MSB of the counter                           !!!

architecture uartw_arch of uartw is

    -- Finite State Machine (FSM) constants:

    type ts is (sRdy, sStr, sSnd, sStp);

    -- - sRdy is for Ready
    -- - sStr is for Start signal
    -- - sSnd is for Sending
    -- - sStp is for Stop signal

    -- state variable
    signal s : ts := sRdy;

    -- bit pointer
    signal p : integer range 0 to 7 := 0;

    -- time counter:  
    signal c : std_logic_vector(7 downto 0);

    -- (128 cycles is one UART pulse width: counter bit 7 high)
    -- (64 cycles is half a UART pulse width: counter bit 6 high)
    -- serial port baud rate must be set at 781250 bit/s
    -- This gives 781250*128 = 100 000 000 Hz = clock frequency

    begin

        pUARTW : process (t)

        begin

            if rising_edge (t) then

                case s is
                
                    ----------------
                    --    READY
                    ----------------

                    -- (wait for start signal)

                    when sRdy =>

                        if l = '1' then    -- find level high
                            s <= sStr;     --> go to start
                        else               -- find level low
                            s <= sRdy;     --> continue
                        end if;
                        
                        c <= (others => '0'); -- keep counter clear
                        o <= '1';             -- keep ouput high
                        p <=  0 ;             -- keep pointer clear 

                    ----------------
                    --    START
                    ----------------
                    
                    -- (wait a full period with ouput low)

                    when sStr =>

                        -- (one full period is 128 clock cycles)

                        o <= '0'; -- keep bit low

                        if c(7) = '1' then -- ## full period reached
                            
                            c <= (others => '0'); --> clear counter
                            s <= sSnd;            --> go to sending

                        else               -- ## keep waiting

                            -- increment counter
                            c <= std_logic_vector(unsigned(c)+1);
                            s <= sStr; --> continue
                        
                        end if;

                    ----------------
                    --   SENDING
                    ----------------

                    -- (wait 8 periods while sending serial data bits)

                    when sSnd =>

                        -- (one full period is 128 clock cycles)
                        
                        o <= i(p); -- ouput held at data value

                        if c(7) = '1' then -- ## full period reached
                            
                            c <= (others => '0'); -- clear counter
                            
                            if p = 7 then         -- found last bit
                                s <= sStp;        --> go to stop
                            else                  -- not last bit
                                p <= p + 1;       --> increment pointer
                                s <= sSnd;        --> continue
                            end if;

                        else               -- ## keep waiting

                            -- increment counter
                            c <= std_logic_vector(unsigned(c)+1);
                            s <= sSnd; --> continue

                        end if;

                    ----------------
                    --    STOP
                    ----------------

                    -- (wait a full period with ouput high)

                    when sStp =>

                        -- (one full period is 128 clock cycles)

                        o <= '1'; -- keep bit high

                        if c(7) = '1' then -- ## full period reached

                            s <= sRdy;            -- go to ready

                        else               -- ## keep waiting

                            -- increment counter
                            c <= std_logic_vector(unsigned(c)+1);
                            s <= sStp; --> continue

                        end if;

                    ----------------
                    --    DONE
                    ----------------

                end case;
            end if;
        end process pUARTW;
-- done
end architecture uartw_arch;

-------------------------------------------------
