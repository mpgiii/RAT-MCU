----------------------------------------------------------------------------------
-- Engineer: 
-- 
-- Create Date: 10/08/2018 05:31:52 PM
-- Module Name: ALU - TopMod
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ALU is
    Port ( SEL : in STD_LOGIC_VECTOR (3 downto 0);
           A : in STD_LOGIC_VECTOR (7 downto 0);
           B : in STD_LOGIC_VECTOR (7 downto 0);
           CIN : in STD_LOGIC;
           RESULT : out STD_LOGIC_VECTOR (7 downto 0);
           C : out STD_LOGIC;
           Z : out STD_LOGIC);
end ALU;

architecture TopMod of ALU is

begin

    instructions : process (A,B,CIN,SEL)
        variable vRESULT : STD_LOGIC_VECTOR (8 downto 0) := "000000000";
    
    begin    
    vRESULT := "000000000";
    RESULT <= "00000000";
    C <= '0';
    Z <= '0';
        case SEL is
            when "0000" =>
                vRESULT := ('0' & A) + ('0' & B);
            when "0001" =>
                vRESULT := ('0' & A) + ('0' & B) + CIN;
            when "0010" =>
                vRESULT := ('0' & A) - ('0' & B);
            when "0011" =>
                vRESULT := ('0' & A) - ('0' & B) - CIN;
            when "0100" =>
                vRESULT := ('0' & A) - ('0' & B);
            when "0101" =>
                vRESULT := ('0' & A) and ('0' & B);
            when "0110" =>
                vRESULT := ('0' & A) or ('0' & B);
            when "0111" =>
                vRESULT := ('0' & A) xor ('0' & B);
            when "1000" =>
                vRESULT := ('0' & A) and ('0' & B);
            when "1001" =>
                vRESULT := (A & CIN);
            when "1010" =>
                vRESULT := (A(0) & CIN & A(7 downto 1));
            when "1011" =>
                vRESULT := (A(7) & A(6 downto 0) & A(7));
            when "1100" =>
                vRESULT := (A(0) & A(0) & A(7 downto 1));
            when "1101" =>
                vRESULT := (A(0) & A(7) & A(7 downto 1));
            when "1110" =>
                vRESULT := (CIN & B);
            when others =>
                vRESULT := "000000000";
        end case;
        RESULT <= vRESULT(7 downto 0);
        C <= vRESULT(8);
        if vRESULT(7 downto 0) = "00000000" then
            Z <= '1';
        end if;
                
    end process instructions;   


end TopMod;