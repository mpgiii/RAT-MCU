---------------------------------------------------------------------------------
-- Engineer: Michael Georgariou and Jack Ellison
-- 
-- Create Date: 10/17/2018 05:12:49 PM
-- Module Name: FLAGS - Behavioral
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FLAGS is
    Port ( 
           FLG_Z_LD : in STD_LOGIC;
           Z : in STD_LOGIC;
           
           FLG_C_SET : in STD_LOGIC;
           FLG_C_LD : in STD_LOGIC;
           FLG_C_CLR : in STD_LOGIC;
           C : in STD_LOGIC;
           
           CLK : in STD_LOGIC;
           
           Z_FLAG : out STD_LOGIC;
           C_FLAG : out STD_LOGIC);
end FLAGS;

architecture Behavioral of FLAGS is

begin

    z_stuff: process (CLK, FLG_Z_LD)
    begin
        if rising_edge(CLK) then
            if (FLG_Z_LD = '1') then
                Z_FLAG <= Z;
            end if;
        end if;
                    
    end process z_stuff;
    
    c_stuff: process (CLK, FLG_C_SET, FLG_C_LD, FLG_C_CLR)
    begin
        if rising_edge(CLK) then
            if (FLG_C_SET = '1') then
                C_FLAG <= '1';
            elsif (FLG_C_CLR = '1') then
                C_FLAG <= '0';
            elsif (FLG_C_LD = '1' and FLG_C_SET = '0' and FLG_C_CLR = '0') then
                C_FLAG <= C;
            end if;
        end if;
    end process c_stuff;

end Behavioral;
