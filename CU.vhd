----------------------------------------------------------------------------------
-- Engineer: Jack Ellison, Michael Georgariou
-- 
-- Create Date: 10/17/2018 04:48:17 PM
-- Design Name: CU
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CU is
    Port ( C_FLAG : in STD_LOGIC;
           Z_FLAG : in STD_LOGIC;
           INT : in STD_LOGIC;
           RESET : in STD_LOGIC;
           OPCODE_HI_5 : in STD_LOGIC_VECTOR (4 downto 0);
           OPCODE_LO_2 : in STD_LOGIC_VECTOR (1 downto 0);
           CLK : in STD_LOGIC;
           I_SET : out STD_LOGIC;
           I_CLR : out STD_LOGIC;
           PC_LD : out STD_LOGIC;
           PC_INC : out STD_LOGIC;
           PC_MUX_SEL : out STD_LOGIC_VECTOR (1 downto 0);
           ALU_OPY_SEL : out STD_LOGIC;
           ALU_SEL : out STD_LOGIC_VECTOR (3 downto 0);
           RF_WR : out STD_LOGIC;
           RF_WR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
           SP_LD : out STD_LOGIC;
           SP_INCR : out STD_LOGIC;
           SP_DECR : out STD_LOGIC;
           SCR_WE : out STD_LOGIC;
           SCR_ADDR_SEL : out STD_LOGIC_VECTOR (1 downto 0);
           SCR_DATA_SEL : out STD_LOGIC;
           FLG_C_SET : out STD_LOGIC;
           FLG_C_CLR : out STD_LOGIC;
           FLG_C_LD : out STD_LOGIC;
           FLG_Z_LD : out STD_LOGIC;
           FLG_LD_SEL : out STD_LOGIC;
           FLG_SHAD_LD : out STD_LOGIC;
           RST : out STD_LOGIC;
           IO_STRB : out STD_LOGIC);
end CU;

architecture Behavioral of CU is

TYPE State_type is (ST_INIT, ST_FETCH, ST_EXEC);
signal PS, NS : State_type;
signal OP_CODE_7 : STD_LOGIC_VECTOR(6 downto 0);

begin

    OP_CODE_7 <= OPCODE_HI_5 & OPCODE_LO_2;

    sync_proc : process (CLK, RESET)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                PS <= ST_INIT;
            else
                PS <= NS;
            end if;
        end if;
    end process sync_proc;
    
    async_proc : process (PS, OP_CODE_7, C_FLAG, Z_FLAG)
    begin
        I_SET <= '0';
        I_CLR <= '0';
        PC_LD <= '0';
        PC_INC <= '0';
        PC_MUX_SEL <= "00";
        ALU_OPY_SEL <= '0';
        ALU_SEL <= "0000";
        RF_WR <= '0';
        RF_WR_SEL <= "00";
        SP_LD <= '0';
        SP_INCR <= '0';
        SP_DECR <= '0';
        SCR_WE <= '0';
        SCR_ADDR_SEL <= "00";
        SCR_DATA_SEL <= '0';
        FLG_C_SET <= '0';
        FLG_C_CLR <= '0';
        FLG_C_LD <= '0';
        FLG_Z_LD <= '0';
        FLG_LD_SEL <= '0';
        FLG_SHAD_LD <= '0';
        RST <= '0';
        IO_STRB <= '0';
        
        case (PS) is
            when ST_INIT =>
                RST <= '1';
                FLG_C_CLR <= '1';
                NS <= ST_FETCH;
            when ST_FETCH =>
                PC_INC <= '1';
                NS <= ST_EXEC;
            when ST_EXEC =>
                NS <= ST_FETCH;
                case (OP_CODE_7) is
                    when "0000000" =>           -- Reg-Reg AND
                        RF_WR <= '1';
                        ALU_SEL <= "0101";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                    when "0000001" =>           -- Reg-Reg OR
                        RF_WR <= '1';
                        ALU_SEL <= "0110";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                    
                    when "0000010" =>           -- Reg-Reg EXOR ------------------------------------------
                        RF_WR <= '1';
                        ALU_SEL <= "0111";
                    when "0000011" =>           -- Test
                        RF_WR <= '0';
                        ALU_SEL <= "1000";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                    when "0000100" =>           -- Reg-Reg ADD
                        RF_WR <= '1';
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                    when "0000101" =>           -- Reg-Reg ADDC
                        RF_WR <= '1';
                        ALU_SEL <= "0001";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0000110" =>           -- Reg-Reg SUB
                        RF_WR <= '1';
                        ALU_SEL <= "0010";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0000111" =>           -- Reg-Reg SUBC
                        RF_WR <= '1';
                        ALU_SEL <= "0011";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0001000" =>           -- Reg-Reg CMP
                        RF_WR <= '0';
                        ALU_SEL <= "0100";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0001001" =>           -- Reg-Reg Mov
                        RF_WR <= '1';
                        ALU_SEL <= "1110";
                    when "0001010" =>           -- Reg-(Reg) LD
                        RF_WR <= '1';
                        RF_WR_SEL <= "01";
                    when "0001011" =>           -- (Reg)-Reg ST ------------------------------------------
                        SCR_WE <= '1';
                    when "0010000" =>           -- BRN
                        PC_LD <= '1';
                    when "0010010" =>           -- BREQ
                        if Z_FLAG = '1' then
                            PC_LD <= '1';
                        end if;
                    when "0010011" =>           -- BRNE
                        if Z_FLAG = '0' then
                            PC_LD <= '1';
                        end if;
                    when "0010100" =>           -- BRCS
                        if C_FLAG = '1' then
                            PC_LD <= '1';
                        end if;
                    when "0010101" =>           -- BRCC
                        if C_FLAG = '0' then
                            PC_LD <= '1';
                        end if;
                    when "0100000" =>           -- LSL
                        RF_WR <= '1';
                        ALU_SEL <= "1001";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0100001" =>           -- LSR
                        RF_WR <= '1';
                        ALU_SEL <= "1010";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0100010" =>           -- ROL
                        RF_WR <= '1';
                        ALU_SEL <= "1011";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0100011" =>           -- ROR
                        RF_WR <= '1';
                        ALU_SEL <= "1100";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0100100" =>           -- ASR
                        RF_WR <= '1';
                        ALU_SEL <= "1101";
                        FLG_Z_LD <= '1';
                        FLG_C_LD <= '1';
                    when "0110000" =>           -- CLC
                        FLG_C_CLR <= '1';
                    when "0110001" =>           -- SEC
                        FLG_C_SET <= '1';
                    when "1000000" | "1000001" | "1000010" | "1000011" =>           -- Reg-Im AND
                        RF_WR <= '1';
                        ALU_SEL <= "0101";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                        ALU_OPY_SEL <= '1';
                    when "1000100" | "1000101" | "1000110" | "1000111" =>           -- Reg-Im OR
                        RF_WR <= '1';
                        ALU_SEL <= "0110";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                        ALU_OPY_SEL <= '1';
                    when "1001000" | "1001001" | "1001010" | "1001011" =>           -- Reg-Im EXOR
                        RF_WR <= '1';
                        ALU_SEL <= "0111";
                        ALU_OPY_SEL <= '1';
                    when "1001100" | "1001101" | "1001110" | "1001111" =>           -- Reg-Im TEST
                        RF_WR <= '0';
                        ALU_SEL <= "1000";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                        ALU_OPY_SEL <= '1';
                    when "1010000" | "1010001" | "1010010" | "1010011" =>           -- Reg-Im ADD
                        RF_WR <= '1';
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                        ALU_OPY_SEL <= '1';
                    when "1010100" | "1010101" | "1010110" | "1010111" =>           -- Reg-Im ADDC
                        RF_WR <= '1';
                        ALU_SEL <= "0001";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                        ALU_OPY_SEL <= '1';
                    when "1011000" | "1011001" | "1011010" | "1011011" =>           -- Reg-Im SUB
                        RF_WR <= '1';
                        ALU_SEL <= "0010";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                        ALU_OPY_SEL <= '1';
                    when "1011100" | "1011101" | "1011110" | "1011111" =>           -- Reg-Im SUBC
                        RF_WR <= '1';
                        ALU_SEL <= "0011";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                        ALU_OPY_SEL <= '1';
                    when "1100000" | "1100001" | "1100010" | "1100011" =>           -- Reg-Im CMP
                        RF_WR <= '0';
                        ALU_SEL <= "0100";
                        FLG_C_LD <= '1';
                        FLG_Z_LD <= '1';
                        ALU_OPY_SEL <= '1';
                    when "1100100" | "1100101" | "1100110" | "1100111" =>           -- In
                        RF_WR <= '1';
                        RF_WR_SEL <= "11";
                    when "1101000" | "1101001" | "1101010" | "1101011" =>           -- Out
                        IO_STRB <= '1';
                    when "1101100" | "1101101" | "1101110" | "1101111" =>           -- Reg-Im Mov
                        RF_WR <= '1';
                        ALU_SEL <= "1110";
                        ALU_OPY_SEL <= '1';
                    when "1110000" | "1110001" | "1110010" | "1110011" =>           -- Reg-Im LD
                        RF_WR <= '1';
                        RF_WR_SEL <= "01";
                        SCR_ADDR_SEL <= "01";
                    when "1110100" | "1110101" | "1110110" | "1110111" =>           -- Reg-Im ST
                        SCR_DATA_SEL <= '1';
                        SCR_WE <= '1';
                    when others =>
                end case;
            when others =>
                    NS <= ST_INIT;
        end case;
    end process async_proc;             
    

end Behavioral;

