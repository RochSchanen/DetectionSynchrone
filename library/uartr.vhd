-- ########################################################

-- file: uartr.vhd
-- content: UART read (FPGA receives data)
-- Created: 2020 september 06
-- Author: Roch Schanen
-- comments:

-- ########################################################





-------------------------------------------------
--                   UARTR
-------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------

entity uartr is
    port (t : in  std_logic;                      -- clock (rising edge)
          i : in  std_logic;                      -- data in
          v : out std_logic;                      -- validate
          o : out std_logic_vector (7 downto 0)); -- data out
end entity uartr;

-------------------------------------------------

-- NOTE TO DO: maybe only clear the MSB of the counter                           !!!

architecture uartr_arch of uartr is

    -- Finite State Machine (FSM) constants:

    type ts is (sRdy, sStr, sRcv, sStp);

    -- - sRdy is for Ready
    -- - sStr is for Start signal
    -- - sRcv is for Receiving
    -- - sStp is for Stop signal

    -- state variable
    signal s : ts := sRdy;

    -- bit pointer
    signal p : integer range 0 to 7 := 0;

    -- time counter:  
    signal c : std_logic_vector(7 downto 0);

    -- (128 cycles is one UART pulse width: counter bit 7 raised)
    -- (64 cycles is half a UART pulse width: counter bit 6 raised)
    -- serial port baud rate must be set at 781250 bit/s
    -- This gives 781250*128 = 100 000 000 Hz = clock frequency

    begin

        pUARTR : process (t)

        begin

            if rising_edge (t) then

                case s is
                
                    ----------------
                    --    READY
                    ----------------

                    -- (wait for start signal)

                    when sRdy =>

                        if i = '0' then    -- find level low
                            s <= sStr;     --> go to start
                        else               -- find level high
                            s <= sRdy;     --> continue
                        end if;
                        
                        c <= (others => '0'); -- keep counter  clear
                        v <= '0';             -- keep validate clear
                        p <= 0;               -- keep pointer  clear 

                    ----------------
                    --    START
                    ----------------
                    
                    -- (wait half a period = 64 clock cycles)

                    when sStr =>

                        if c(6) = '1' then -- half period reached
                            
                            if i = '0' then           -- confirm start
                                c <= (others => '0'); --> clear counter
                                s <= sRcv;            --> go to receive
                            else                      -- start fail 
                                s <= sRdy;            --> go to ready
                            end if;

                        else               -- keep waiting

                            -- increment counter
                            c <= std_logic_vector(unsigned(c)+1);
                            s <= sStr; --> continue
                        
                        end if;

                    ----------------
                    --   RECEIVE
                    ----------------

                    -- (wait 8 periods and record one data bit for each period)

                    when sRcv =>

                        -- (one full period is 128 clock cycles)
                        
                        if c(7) = '1' then -- full period reached
                            
                            c <= (others => '0'); -- clear counter
                            o(p) <= i;            -- record data bit
                            
                            if p = 7 then         -- found last bit
                                s <= sStp;        --> go to stop
                            else                  -- not last bit
                                p <= p + 1;       --> increment pointer
                                s <= sRcv;        --> continue
                            end if;

                        else               -- wait for full period

                            -- increment counter
                            c <= std_logic_vector(unsigned(c)+1);
                            s <= sRcv; --> continue

                        end if;


                    ----------------
                    --    STOP
                    ----------------

                    -- (wait one full period and set validate signal)

                    when sStp =>

                        -- (one full period is 128 clock cycles)

                        if c(7) = '1' then -- full period reached

                            v <= '1';             -- set validate
                            s <= sRdy;            -- go to ready

                        else               -- wait for full period

                            -- increment counter
                            c <= std_logic_vector(unsigned(c)+1);
                            s <= sStp; --> continue

                        end if;

                    ----------------
                    --    DONE
                    ----------------

                end case;
            end if;
        end process pUARTR;
-- done
end architecture uartr_arch;

-------------------------------------------------
