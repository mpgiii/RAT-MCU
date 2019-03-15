library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PC is
    Port (
        PC_MUX_SEL : in STD_LOGIC_VECTOR(1 downto 0);
        FROM_IMMED : in STD_LOGIC_VECTOR(9 downto 0);
        FROM_STACK : in STD_LOGIC_VECTOR(9 downto 0);
        LAST_ADDR : in STD_LOGIC_VECTOR(9 downto 0);
        PC_LD: IN std_logic; -- load data
        PC_INC: IN std_logic; -- increment data
        RST: IN std_logic; -- reset
        CLK: IN std_logic;
        PC_COUNT: OUT std_logic_vector(9 downto 0) -- count output
    );
end PC;

architecture Behavioral of PC is

    component MUX is
        Port ( 
            PC_MUX_SEL : in STD_LOGIC_VECTOR(1 downto 0);
            FROM_IMMED : in STD_LOGIC_VECTOR(9 downto 0);
            FROM_STACK : in STD_LOGIC_VECTOR(9 downto 0);
            LAST_ADDR : in STD_LOGIC_VECTOR(9 downto 0);
            D3 : in STD_LOGIC_VECTOR(9 downto 0);
            OUTPUT : out STD_LOGIC_VECTOR(9 downto 0));
    end component;
    
    component ProgramCounter is
        Port (
            D_IN: IN std_logic_vector(9 downto 0); -- data in
            PC_LD: IN std_logic; -- load data
            PC_INC: IN std_logic; -- increment data
            RST: IN std_logic; -- reset
            CLK: IN std_logic;
            PC_COUNT: OUT std_logic_vector(9 downto 0) -- count output
        );
    end component;
    
    signal s_din : STD_LOGIC_VECTOR(9 downto 0);

begin

    MUX0 : MUX
        port map (
            PC_MUX_SEL => PC_MUX_SEL,
            FROM_IMMED => FROM_IMMED,
            FROM_STACK => FROM_STACK,
            LAST_ADDR => LAST_ADDR,
            D3 => "0000000000",
            OUTPUT => s_din
        );
        
    ProgramCounter0 : ProgramCounter
        port map (
            D_IN => s_din,
            PC_LD => PC_LD,
            PC_INC => PC_INC,
            RST => RST,
            CLK => CLK,
            PC_COUNT => PC_COUNT
        );

end Behavioral;
