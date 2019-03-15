----------------------------------------------------------------------------------
-- Engineer: Jack Ellison and Michael Georgariou
-- 
-- Create Date: 10/06/2018 10:47:27 PM
-- Module Name: REG_FILE - TopMod
----------------------------------------------------------------------------------


library IEEE;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_1164.ALL;


entity REG_FILE is
    Port ( DIN : in STD_LOGIC_VECTOR (7 downto 0);
           ADRX : in STD_LOGIC_VECTOR (4 downto 0);
           ADRY : in STD_LOGIC_VECTOR (4 downto 0);
           RF_WR : in STD_LOGIC;
           CLK : in STD_LOGIC;
           DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
           DY_OUT : out STD_LOGIC_VECTOR (7 downto 0));
end REG_FILE;

architecture TopMod of REG_FILE is

    TYPE RegArray is ARRAY (0 to 31) of STD_LOGIC_VECTOR (7 downto 0);
    signal sData : RegArray := (others => (others => '0'));
    
begin

    sync_proc : process (RF_WR, CLK)
    begin
        if (Rising_Edge(CLK)) then
            if RF_WR = '1' then
                sData(to_integer(unsigned(ADRX))) <= DIN;
            end if;
        end if;
    end process sync_proc;
    
    DX_OUT <= sData(to_integer(unsigned(ADRX)));
    DY_OUT <= sData(to_integer(unsigned(ADRY)));
    
            

end TopMod;