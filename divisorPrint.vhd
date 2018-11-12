library IEEE;
use IEEE.STD_Logic_1164.all;

entity divisorPrint is
	PORT(
		clk_vga					:	in STD_LOGIC;
		clk25    				:	out STD_LOGIC
	);
end;

architecture behavioral of divisorPrint is

signal clk	: STD_LOGIC := '0'; 
begin

	divisor25 : process(clk_vga) is
			variable cuenta : INTEGER range 0 to 100000 := 0;
		begin
			if rising_edge(clk_vga) then
				if cuenta = 100000 then
					cuenta := 0;
					clk <= not(clk);
				else
					cuenta := cuenta + 2;
				end if;
			end if;
		end process divisor25;
		
		clk25 <= clk;
	
end architecture behavioral;