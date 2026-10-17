----------------------------------------------------------------------------------
-- Module : cpu_top
-- Top level of the 8-bit accumulator CPU (Set 0).
-- Only connects the blocks together, there is no logic here.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity cpu_top is
    Port (
        -- clock
        CLK    : in  STD_LOGIC;
        -- synchronous, active-high reset
        RESET  : in  STD_LOGIC;
        -- accumulator value (CPU output)
        Q      : out STD_LOGIC_VECTOR(7 downto 0);
        -- zero flag
        Z      : out STD_LOGIC;
        -- program counter value (for checking)
        PC_OUT : out STD_LOGIC_VECTOR(3 downto 0)
    );
end cpu_top;


architecture Structural of cpu_top is

    -- program counter value, used as ROM address
    signal pc_value   : STD_LOGIC_VECTOR(3 downto 0);
    -- full 12-bit instruction from the ROM
    signal instr      : STD_LOGIC_VECTOR(11 downto 0);
    -- first 4 bits of the instruction
    signal opcode     : STD_LOGIC_VECTOR(3 downto 0);
    -- last 8 bits of the instruction
    signal operand    : STD_LOGIC_VECTOR(7 downto 0);
	 
	 
	 -- control signals from the control unit
    signal alu_op     : STD_LOGIC_VECTOR(1 downto 0);
    signal acc_en     : STD_LOGIC;
    signal z_en       : STD_LOGIC;
    signal pc_load    : STD_LOGIC;



	 -- data signals
    signal acc_value  : STD_LOGIC_VECTOR(7 downto 0);
    signal alu_result : STD_LOGIC_VECTOR(7 downto 0);
    signal alu_zero   : STD_LOGIC;
    signal z_value    : STD_LOGIC;
	 
	 
begin

    -- split the instruction into opcode and operand
    opcode  <= instr(11 downto 8);
    operand <= instr(7 downto 0);
		
	 -- Program Counter: counts up, or jumps when pc_load = 1
    PC_UNIT : entity work.pc
        port map (
            CLK   => CLK,
            RESET => RESET,
            LOAD  => pc_load,
            D     => operand(3 downto 0),
            Q     => pc_value
        );
		  
		  
	 -- Program ROM: gives the instruction at the PC address
    ROM_UNIT : entity work.program_rom
        port map (
            ADDR  => pc_value,
            INSTR => instr
        );
		  
		  
	 -- Control Unit: decodes the opcode
    CONTROL_UNIT : entity work.control_unit
        port map (
            OPCODE  => opcode,
            Z       => z_value,
            ALU_OP  => alu_op,
            ACC_EN  => acc_en,
            Z_EN    => z_en,
            PC_LOAD => pc_load
        );
		  
		  
		-- ALU: works on ACC and the operand
    ALU_UNIT : entity work.alu
        port map (
            A      => acc_value,
            B      => operand,
            OP     => alu_op,
            RESULT => alu_result,
            ZERO   => alu_zero
        );

    -- Accumulator: stores the ALU result
	 ACC_UNIT : entity work.acc_register
        port map (
            CLK   => CLK,
            RESET => RESET,
            EN    => acc_en,
            D     => alu_result,
            Q     => acc_value
        );
		  
		  
	 -- Zero flag: stores whether the result was zero
    Z_UNIT : entity work.z_register
        port map (
            CLK   => CLK,
            RESET => RESET,
            EN    => z_en,
            D     => alu_zero,
            Q     => z_value
        );
		  
		  
	 -- connect internal signals to the CPU outputs
    Q      <= acc_value;
    Z      <= z_value;
    PC_OUT <= pc_value;

end Structural;
	 