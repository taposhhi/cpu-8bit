----------------------------------------------------------------------------------
-- Module : acc_register
-- 8-bit accumulator. Its output is the CPU output Q[7:0].
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity acc_register is
    Port (
        -- clock
        CLK   : in  STD_LOGIC;
        -- 1 = clear the accumulator to 0x00
        RESET : in  STD_LOGIC;
        -- 1 = load the new value D, 0 = keep the old value
        EN    : in  STD_LOGIC;
        -- new value (from the ALU)
        D     : in  STD_LOGIC_VECTOR(7 downto 0);
        -- stored value
        Q     : out STD_LOGIC_VECTOR(7 downto 0)
    );
end acc_register;

architecture Behavioral of acc_register is
    -- the stored value
    signal acc_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
	 
begin

    process(CLK)
    begin
        -- act only on the clock's rising edge
        if rising_edge(CLK) then
            -- reset has the highest priority
            if RESET = '1' then
                acc_reg <= (others => '0');
            -- load only when enabled
            elsif EN = '1' then
                acc_reg <= D;
            end if;
        end if;
    end process;

    -- send the stored value out
    Q <= acc_reg;

end Behavioral;