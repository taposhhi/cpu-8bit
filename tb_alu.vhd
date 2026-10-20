----------------------------------------------------------------------------------
-- Module : tb_alu (testbench for the ALU)
-- Checks LDI, ADD, AND, NOT and the ZERO flag with edge cases.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_alu is
end tb_alu;

architecture Behavioral of tb_alu is

    -- signals connected to the ALU
    signal A      : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    signal B      : STD_LOGIC_VECTOR(7 downto 0) := x"00";
    signal OP     : STD_LOGIC_VECTOR(1 downto 0) := "00";
    signal RESULT : STD_LOGIC_VECTOR(7 downto 0);
    signal ZERO   : STD_LOGIC;
	 
	 
begin

    -- the ALU under test
    UUT : entity work.alu
        port map (
            A      => A,
            B      => B,
            OP     => OP,
            RESULT => RESULT,
            ZERO   => ZERO
        );

    -- test sequence
	 stim_process : process

        -- apply inputs, wait, then compare RESULT and ZERO
        procedure check (
            in_a     : in STD_LOGIC_VECTOR(7 downto 0);
            in_b     : in STD_LOGIC_VECTOR(7 downto 0);
            in_op    : in STD_LOGIC_VECTOR(1 downto 0);
            exp_res  : in STD_LOGIC_VECTOR(7 downto 0);
            exp_zero : in STD_LOGIC;
            name     : in string) is
				
				
			begin
            A  <= in_a;
            B  <= in_b;
            OP <= in_op;
            wait for 10 ns;
            assert (RESULT = exp_res) and (ZERO = exp_zero)
                report name & " FAILED"
                severity error;
					 
			end procedure;

    begin
        -- LDI: result = B, A is ignored
        check(x"11", x"A5", "00", x"A5", '0', "LDI 0xA5");
        check(x"FF", x"00", "00", x"00", '1', "LDI 0x00 (zero flag)");
		  
		  
		  -- ADD: A + B, carry is dropped
        check(x"0F", x"01", "01", x"10", '0', "ADD 0x0F + 0x01");
        check(x"FF", x"01", "01", x"00", '1', "ADD 0xFF + 0x01 wraps to 0");
        check(x"F0", x"20", "01", x"10", '0', "ADD 0xF0 + 0x20 wraps");

		  -- AND: bit by bit
        check(x"A5", x"5A", "10", x"00", '1', "AND A5 with 5A gives 0");
		  check(x"FF", x"0F", "10", x"0F", '0', "AND FF with 0F mask");

        -- NOT: flip every bit of A, B is ignored
        check(x"00", x"00", "11", x"FF", '0', "NOT 0x00");
        check(x"FF", x"00", "11", x"00", '1', "NOT 0xFF = 0");
        check(x"AA", x"00", "11", x"55", '0', "NOT 0xAA");
		  
		  report "ALU test finished. If no FAILED message above, all checks passed."
            severity note;
        wait;
    end process;

end Behavioral;