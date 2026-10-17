----------------------------------------------------------------------------------
-- Module : alu
-- 8-bit combinational ALU for Set 0: LDI, ADD, AND, NOT.
-- LDI is done by passing operand B straight through, so no extra mux is needed.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity alu is
    Port (
        -- A = accumulator value
        A      : in  STD_LOGIC_VECTOR(7 downto 0);
        -- B = operand from the instruction
        B      : in  STD_LOGIC_VECTOR(7 downto 0);
        -- operation select: 00 = LDI, 01 = ADD, 10 = AND, 11 = NOT
        OP     : in  STD_LOGIC_VECTOR(1 downto 0);
        -- result of the operation
        RESULT : out STD_LOGIC_VECTOR(7 downto 0);
        -- 1 when the result is 0x00
        ZERO   : out STD_LOGIC
		);
end alu;

architecture Behavioral of alu is
    -- result before it is sent out
    signal res : STD_LOGIC_VECTOR(7 downto 0);
begin

    -- choose the operation
    process(A, B, OP)
    begin
			case OP is
            -- LDI: pass the operand through
            when "00" =>
                res <= B;
            -- ADD: A + B (carry is dropped)
            when "01" =>
                res <= STD_LOGIC_VECTOR(unsigned(A) + unsigned(B));
            -- AND: bit by bit
            when "10" =>
                res <= A and B;
            -- NOT: flip every bit of A
            when others =>
                res <= not A;
        end case;
	 end process;

    -- send the result out
    RESULT <= res;

    -- zero flag: 1 if every bit of the result is 0
    ZERO <= '1' when res = x"00" else '0';

end Behavioral;