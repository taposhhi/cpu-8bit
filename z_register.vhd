----------------------------------------------------------------------------------
-- Module : z_register
-- 1-bit zero flag. Z = 1 when the last value written to ACC was 0x00.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity z_register is
    Port (
        -- clock
        CLK   : in  STD_LOGIC;
        -- 1 = set the flag to 1
        RESET : in  STD_LOGIC;
        -- 1 = update the flag, 0 = keep the old value
        EN    : in  STD_LOGIC;
        -- new flag value (from the ALU zero output)
        D     : in  STD_LOGIC;
        -- stored flag
        Q     : out STD_LOGIC
    );
end z_register;


architecture Behavioral of z_register is
    -- the stored flag (starts at 1, like after a reset)
    signal z_reg : STD_LOGIC := '1';
	 
	 
begin

    process(CLK)
    begin
        -- act only on the clock's rising edge
        if rising_edge(CLK) then
            -- reset sets Z to 1 (not 0!)
            if RESET = '1' then
                z_reg <= '1';
            -- update only when enabled
            elsif EN = '1' then
                z_reg <= D;
            end if;
        end if;
    end process;
	 
	 -- send the flag out
    Q <= z_reg;

end Behavioral;