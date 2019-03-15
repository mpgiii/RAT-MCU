library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX2 is
    Port (
    MUXSEL : in STD_LOGIC;
    A : in STD_LOGIC_VECTOR(7 downto 0);
    B : in STD_LOGIC_VECTOR(7 downto 0);
    OUTPUT : out STD_LOGIC_VECTOR(7 downto 0));
end MUX2;

architecture Behavioral of MUX2 is

begin

    with MUXSEL select OUTPUT <=
        A when '0',
        B when others;

end Behavioral;
