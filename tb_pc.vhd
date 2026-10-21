----------------------------------------------------------------------------------
-- Module : tb_pc (testbench for the program counter)
-- Checks reset, counting, load (JZ jump), wrap-around and reset priority.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_pc is
end tb_pc;


architecture Behavioral of tb_pc is

    -- signals connected to the PC
    signal CLK   : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal LOAD  : STD_LOGIC := '0';
    signal D     : STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal Q     : STD_LOGIC_VECTOR(3 downto 0);

    -- clock period
    constant CLK_PERIOD : time := 10 ns;
	 
begin

    -- the PC under test
    UUT : entity work.pc
        port map (
            CLK   => CLK,
            RESET => RESET,
            LOAD  => LOAD,
            D     => D,
            Q     => Q
        );
		  
	 -- clock generator
    clk_process : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD / 2;
        CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process;
	 
	 -- test sequence
    stim_process : process

        -- compare Q with the expected value
        procedure check (
            exp_q : in STD_LOGIC_VECTOR(3 downto 0);
            name  : in string) is
        begin
            assert (Q = exp_q)
                report name & " FAILED"
                severity error;
        end procedure;
		  
	 begin
        -- reset: PC goes to 0
        RESET <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        check("0000", "RESET");
        RESET <= '0';
		  
		  -- counting: PC + 1 every clock
        wait until rising_edge(CLK);
        wait for 1 ns;
        check("0001", "count to 1");

        wait until rising_edge(CLK);
        wait for 1 ns;
        check("0010", "count to 2");
		  
		  
		  -- load: jump to address 5 (like JZ taken)
        LOAD <= '1';
        D    <= "0101";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check("0101", "load 5");
        LOAD <= '0';

        -- counting continues from the loaded address
        wait until rising_edge(CLK);
        wait for 1 ns;
        check("0110", "count to 6 after load");
		  
		   -- load address 14, so we can test the wrap-around next
        LOAD <= '1';
        D    <= "1110";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check("1110", "load 14");
        LOAD <= '0';

        wait until rising_edge(CLK);
        wait for 1 ns;
        check("1111", "count to 15");
		  
		  
		  -- wrap-around: 15 + 1 = 0 (4-bit counter)
        wait until rising_edge(CLK);
        wait for 1 ns;
        check("0000", "wrap from 15 to 0");

        wait until rising_edge(CLK);
        wait for 1 ns;
        check("0001", "count to 1 after wrap");

		  
		  -- reset has priority over load
        RESET <= '1';
        LOAD  <= '1';
        D     <= "1010";
        wait until rising_edge(CLK);
        wait for 1 ns;
        check("0000", "RESET beats LOAD");
        RESET <= '0';
        LOAD  <= '0';


		  report "PC test finished. If no FAILED message above, all checks passed."
            severity note;
        wait;
    end process;

end Behavioral;