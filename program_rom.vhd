----------------------------------------------------------------------------------
-- Module : program_rom
-- Stores the Set 0 test program (16 locations, 12 bits each).
-- Instruction = 4-bit opcode & 8-bit operand.
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity program_rom is
    Port (
        -- address from the PC
        ADDR  : in  STD_LOGIC_VECTOR(3 downto 0);
        -- instruction stored at that address
        INSTR : out STD_LOGIC_VECTOR(11 downto 0)
    );
end program_rom;


architecture Behavioral of program_rom is

    -- a memory of 16 words, each 12 bits wide
    type rom_array is array (0 to 15) of STD_LOGIC_VECTOR(11 downto 0);

    -- the program (unused addresses hold 000 = NOP)
    constant ROM : rom_array := (
			-- LDI 0xA5
        0 => x"1A5",
        -- AND 0x5A
        1 => x"45A",
        -- JZ 0x05
        2 => x"C05",
        -- ADD 0x01
        3 => x"201",
        -- ADD 0x01
        4 => x"201",
		  -- NOT
        5 => x"700",
        -- AND 0x0F
        6 => x"40F",
        -- JZ 0x00
        7 => x"C00",
        -- ADD 0x01
        8 => x"201",
        -- everything else is NOP
        others => x"000"
	);
	
begin

    -- read the word at ADDR (no clock needed)
    INSTR <= ROM(to_integer(unsigned(ADDR)));

end Behavioral;