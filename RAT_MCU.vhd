----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2018 01:23:11 PM
-- Design Name: 
-- Module Name: PC - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
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

entity RAT_MCU is
    Port ( 
            IN_PORT : in std_logic_vector(7 downto 0);
            RESET : in std_logic;
            INT : in std_logic;
            CLK : in std_logic;
            
            OUT_PORT : out std_logic_vector(7 downto 0);
            PORT_ID : out std_logic_vector(7 downto 0);
            IO_STRB : out std_logic
    );
end RAT_MCU;

architecture Behavioral of RAT_MCU is
    --Program Counter, ProgROM, Register File, ALU, Control Unit, and Flag
    component PC is 
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
    end component;
    
    component prog_rom is
        port (     
            ADDRESS : in std_logic_vector(9 downto 0); 
            INSTRUCTION : out std_logic_vector(17 downto 0); 
            CLK : in std_logic
        );
    end component;
    
    component REG_FILE is
        Port ( 
            DIN : in STD_LOGIC_VECTOR (7 downto 0);
            ADRX : in STD_LOGIC_VECTOR (4 downto 0);
            ADRY : in STD_LOGIC_VECTOR (4 downto 0);
            RF_WR : in STD_LOGIC;
            CLK : in STD_LOGIC;
            DX_OUT : out STD_LOGIC_VECTOR (7 downto 0);
            DY_OUT : out STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    component ALU is
        Port ( 
            SEL : in STD_LOGIC_VECTOR (3 downto 0);
            A : in STD_LOGIC_VECTOR (7 downto 0);
            B : in STD_LOGIC_VECTOR (7 downto 0);
            CIN : in STD_LOGIC;
            RESULT : out STD_LOGIC_VECTOR (7 downto 0);
            C : out STD_LOGIC;
            Z : out STD_LOGIC
        );
    end component;
    
    component CU is
        Port ( 
            C_FLAG : in STD_LOGIC;
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
            IO_STRB : out STD_LOGIC
       );
    end component CU;
    
    component FLAGS is
        Port ( 
            FLG_Z_LD : in STD_LOGIC;
            Z : in STD_LOGIC;
               
            FLG_C_SET : in STD_LOGIC;
            FLG_C_LD : in STD_LOGIC;
            FLG_C_CLR : in STD_LOGIC;
            C : in STD_LOGIC;
               
            CLK : in STD_LOGIC;
               
            Z_FLAG : out STD_LOGIC;
            C_FLAG : out STD_LOGIC
        );
    end component;
    
    component MUX4 is
        Port (
            MUXSEL : in STD_LOGIC_VECTOR(1 downto 0);
            A : in STD_LOGIC_VECTOR(7 downto 0);
            B : in STD_LOGIC_VECTOR(7 downto 0);
            C : in STD_LOGIC_VECTOR(7 downto 0);
            D : in STD_LOGIC_VECTOR(7 downto 0);
            OUTPUT : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    component MUX2 is
        Port (
            MUXSEL : in STD_LOGIC;
            A : in STD_LOGIC_VECTOR(7 downto 0);
            B : in STD_LOGIC_VECTOR(7 downto 0);
            OUTPUT : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    --signals from Control Unit to everything else
    signal ISET, ICLR, PCLD, PCINC, ALUOPYSEL, RFWR, SPLD, SPINCR, SPDECR, SCRWE, SCRDATASEL, FLGCSET, FLGCCLR, FLGCLD, FLGZLD, FLGLDSEL, FLGSHADLD, RSTCU : STD_LOGIC;
    signal PCMUXSEL, RFWRSEL, SCRADDRSEL : STD_LOGIC_VECTOR(1 downto 0);
    signal ALUSEL : STD_LOGIC_VECTOR (3 downto 0);
    
    --signals from Flags to Control Unit
    signal CFLAG, ZFLAG : STD_LOGIC;
    
    --signals from Prog Rom
    signal INST : STD_LOGIC_VECTOR (17 downto 0);
    
    --signals from Scratch RAM
    signal SCROUT : STD_LOGIC_VECTOR (9 downto 0);
    
    --signals from PC
    signal COUNT : std_logic_vector (9 downto 0);
    
    --signals from ALU
    signal ALURES : std_logic_vector (7 downto 0);
    signal Cout : std_logic;
    signal Zout : std_logic;
    
    --signals from Reg File
    signal DXOUT, DYOUT : STD_LOGIC_VECTOR (7 downto 0);
    
    --signal into DIN for REG FILE
    signal D_IN : STD_LOGIC_VECTOR (7 downto 0);
    
    --signal into B for the ALU
    signal ItsB : STD_LOGIC_VECTOR (7 downto 0);
    
    
begin

    PC0 : PC
        port map (
            --note: left out 0x3FF -- not sure how to do that
            PC_MUX_SEL => PCMUXSEL,
            FROM_IMMED => INST(12 downto 3),
            FROM_STACK => SCROUT,
            LAST_ADDR => "1111111111",
            PC_LD => PCLD,
            PC_INC => PCINC, 
            RST => RSTCU,
            CLK => CLK,
            PC_COUNT => COUNT
        );
        
    DINMUX : MUX4
        port map (
            -- note: left out Option three, the output from SP.
            MUXSEL => RFWRSEL,
            A => ALURES,
            B => SCROUT (7 downto 0), --needed only 8 bits. not sure if this was the right 8
            C => "00000000",
            D => IN_PORT,
            OUTPUT => D_IN
        );
        
    REGFILE0 : REG_FILE
        port map (
            DIN => D_IN,
            ADRX => INST (12 downto 8),
            ADRY => INST (7 downto 3),
            RF_WR => RFWR,
            CLK => CLK,
            DX_OUT => DXOUT,
            DY_OUT => DYOUT
        );
        
    PROGROM : prog_rom
        port map (
            ADDRESS => COUNT,
            INSTRUCTION => INST,
            CLK => CLK
        );
        
    ALUMUX : MUX2
        port map (
            MUXSEL => ALUOPYSEL,
            A => DYOUT,
            B => INST (7 downto 0),
            OUTPUT => ItsB
        );
            
    ALU0 : ALU
        port map (
            SEL => ALUSEL,
            A => DXOUT,
            B => ItsB,
            CIN => CFLAG,
            RESULT => ALURES,
            C => Cout,
            Z => Zout
        );
        
    THEFLAGS : FLAGS
        port map (
            FLG_Z_LD => FLGZLD,
            Z => Zout,
            FLG_C_SET => FLGCSET,
            FLG_C_LD => FLGCLD,
            FLG_C_CLR => FLGCCLR,
            C => Cout,
            CLK => CLK,
            Z_FLAG => ZFLAG,
            C_FLAG => CFLAG
        );
        
    ControlUnit : CU
        port map (
            C_FLAG => CFLAG,
            Z_FLAG => ZFLAG,
            INT => INT,
            RESET => RESET,
            OPCODE_HI_5 => INST (17 downto 13),
            OPCODE_LO_2 => INST (1 downto 0),
            CLK => CLK,
            I_SET => ISET,
            I_CLR => ICLR,
            PC_LD => PCLD,
            PC_INC => PCINC,
            PC_MUX_SEL => PCMUXSEL,
            ALU_OPY_SEL => ALUOPYSEL,
            ALU_SEL => ALUSEL,
            RF_WR => RFWR,
            RF_WR_SEL => RFWRSEL,
            SP_LD => SPLD,
            SP_INCR => SPINCR,
            SP_DECR => SPDECR,
            SCR_WE => SCRWE,
            SCR_ADDR_SEL => SCRADDRSEL,
            SCR_DATA_SEL => SCRDATASEL,
            FLG_C_SET => FLGCSET,
            FLG_C_CLR => FLGCCLR,
            FLG_C_LD => FLGCLD,
            FLG_Z_LD => FLGZLD,
            FLG_LD_SEL => FLGLDSEL,
            FLG_SHAD_LD => FLGSHADLD,
            RST => RSTCU,
            IO_STRB => IO_STRB
        );
        
    OUT_PORT <= DXOUT;
    PORT_ID <= INST (7 downto 0);
    SCROUT <= "0000000000";
    

end Behavioral;
