library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX is
    Port (
    PC_MUX_SEL : in STD_LOGIC_VECTOR(1 downto 0);
    FROM_IMMED : in STD_LOGIC_VECTOR(9 downto 0);
    FROM_STACK : in STD_LOGIC_VECTOR(9 downto 0);
    LAST_ADDR : in STD_LOGIC_VECTOR(9 downto 0);
    D3 : in STD_LOGIC_VECTOR(9 downto 0);
    OUTPUT : out STD_LOGIC_VECTOR(9 downto 0));
end MUX;

architecture Behavioral of MUX is

begin

    with PC_MUX_SEL select OUTPUT <=
        FROM_IMMED when "00",
        FROM_STACK when "01",
        LAST_ADDR when "10",
        D3 when others;

end Behavioral;
