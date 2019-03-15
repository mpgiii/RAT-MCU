library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity MUX4 is
    Port (
    MUXSEL : in STD_LOGIC_VECTOR(1 downto 0);
    A : in STD_LOGIC_VECTOR(7 downto 0);
    B : in STD_LOGIC_VECTOR(7 downto 0);
    C : in STD_LOGIC_VECTOR(7 downto 0);
    D : in STD_LOGIC_VECTOR(7 downto 0);
    OUTPUT : out STD_LOGIC_VECTOR(7 downto 0));
end MUX4;

architecture Behavioral of MUX4 is

begin

    with MUXSEL select OUTPUT <=
        A when "00",
        B when "01",
        C when "10",
        D when others;

end Behavioral;
