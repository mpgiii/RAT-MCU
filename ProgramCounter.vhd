library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ProgramCounter is
    Port (
        D_IN: IN std_logic_vector(9 downto 0); -- data in
        PC_LD: IN std_logic; -- load data
        PC_INC: IN std_logic; -- increment data
        RST: IN std_logic; -- reset
        CLK: IN std_logic;
        PC_COUNT: OUT std_logic_vector(9 downto 0) -- count output
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
    signal temp_signal : STD_LOGIC_VECTOR (9 DOWNTO 0); -- temporary signal to store value to be written
begin


    PC: process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '0') then -- if we are not resetting
                if (PC_LD = '1') THEN -- if PC_LD yes, then load in D_IN
                    temp_signal <= D_IN;
                else -- if not, then
                    if (PC_INC = '1') then -- if PC_INC yes, then add to our signal
                        temp_signal <= std_logic_vector(unsigned(temp_signal) + 1);
                    end if;
                end if;
            else
                temp_signal <= "0000000000"; -- this is our reset
            end if;
        end if;


    end process;

    PC_COUNT <= temp_signal; -- output to our pinout

end Behavioral;