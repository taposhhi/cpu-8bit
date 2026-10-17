----------------------------------------------------------------------------------
-- Module : pc (Program Counter)
-- Holds the address of the instruction being executed.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity pc is
    Port (
        -- clock
        CLK   : in  STD_LOGIC;
        -- 1 = go back to address 0
        RESET : in  STD_LOGIC;
        -- 1 = jump to address D (used by JZ)
        LOAD  : in  STD_LOGIC;
        -- jump address
        D     : in  STD_LOGIC_VECTOR(3 downto 0);
        -- current address (goes to the ROM)
        Q     : out STD_LOGIC_VECTOR(3 downto 0)
    );
end pc;


architecture Behavioral of pc is
    -- the stored address
    signal pc_reg : unsigned(3 downto 0) := (others => '0');
	 
	 
	 
begin

    process(CLK)
    begin
        -- act only on the clock's rising edge
        if rising_edge(CLK) then
            -- reset: start from address 0
            if RESET = '1' then
                pc_reg <= (others => '0');
            -- jump: take the new address
				
				elsif LOAD = '1' then
                pc_reg <= unsigned(D);
            -- normal: go to the next instruction
            else
                pc_reg <= pc_reg + 1;
            end if;
        end if;
    end process;
	 
	 -- send the address out
    Q <= STD_LOGIC_VECTOR(pc_reg);

end Behavioral;