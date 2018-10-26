library IEEE;
use IEEE.STD_Logic_1164.all;

entity divisor25 is
	PORT(
		clk					:	in STD_LOGIC;
		clk_vga					:	out STD_LOGIC
	);
end;

 
architecture behavioral of divisor25 is	
begin
		
	reloj : process (clk)  is
		variable clock : STD_LOGIC := '0';
	begin
		if rising_edge(clk) then 
			clock := not(clock);
		end if;
		clk_vga <= clock;
	end process reloj;
	
end architecture behavioral;