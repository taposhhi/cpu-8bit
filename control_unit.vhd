----------------------------------------------------------------------------------
-- Module : control_unit
-- Reads the opcode and tells the other blocks what to do.
-- Set 0 instructions: LDI, ADD, AND, NOT, JZ. Any other opcode is a NOP.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        -- opcode from the instruction (bits 11..8)
        OPCODE  : in  STD_LOGIC_VECTOR(3 downto 0);
        -- current zero flag (needed to decide if JZ jumps)
        Z       : in  STD_LOGIC;
			
		  -- ALU operation: 00 = LDI, 01 = ADD, 10 = AND, 11 = NOT
        ALU_OP  : out STD_LOGIC_VECTOR(1 downto 0);
        -- 1 = write the ALU result into ACC
        ACC_EN  : out STD_LOGIC;
        -- 1 = update the Z flag
        Z_EN    : out STD_LOGIC;
        -- 1 = PC jumps to the operand address (JZ taken)
        PC_LOAD : out STD_LOGIC
    );
end control_unit;

architecture Behavioral of control_unit is
begin

    process(OPCODE, Z)
    begin
        -- default values = NOP (do nothing)
        ALU_OP  <= "00";
        ACC_EN  <= '0';
        Z_EN    <= '0';
        PC_LOAD <= '0';
			
		  case OPCODE is
            -- LDI: ACC <- operand
            when "0001" =>
                ALU_OP <= "00";
                ACC_EN <= '1';
                Z_EN   <= '1';

            -- ADD: ACC <- ACC + operand
				when "0010" =>
                ALU_OP <= "01";
                ACC_EN <= '1';
                Z_EN   <= '1';

            -- AND: ACC <- ACC AND operand
				when "0100" =>
                ALU_OP <= "10";
                ACC_EN <= '1';
                Z_EN   <= '1';

            -- NOT: ACC <- NOT ACC
				when "0111" =>
                ALU_OP <= "11";
                ACC_EN <= '1';
                Z_EN   <= '1';

            -- JZ: jump only if Z = 1, ACC and Z stay unchanged
            when "1100" =>
                PC_LOAD <= Z;

            -- any other opcode: NOP
				when others =>
                null;
        end case;
    end process;

end Behavioral;