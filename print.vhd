library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity print is
	PORT(
		clk_vga					:	in STD_LOGIC;
		column, row				:	in INTEGER;
		vga_R, vga_G,vga_B	:	out STD_LOGIC_VECTOR(3 downto 0);
		pintar					:	in	STD_LOGIC
	);
end;
 
architecture behavioral of print is

-- Resolucion de la imagen de salida
constant h_video	:	INTEGER := 640;	-- pixeles horizontales
constant v_video	:	INTEGER := 480;	-- pixeles verticales

--- Señal de reloj a 25H  -----
signal clk25	: STD_LOGIC := '0';

begin

	divisor25 : process(clk_vga) is
		variable cuenta : INTEGER := 0;
	begin
		if rising_edge(clk_vga) then
			if cuenta = 1000000 then
				cuenta := 0;
				clk25 <= not(clk25);
			else
				cuenta := cuenta + 2;
			end if;
		end if;
	end process divisor25;
	
	
	mover_figura : process()

	-- Proceso para mostrar en la pantalla el pixel que queremos 
	-- con el color deseado
	mostrar_pixel:	process (clk_vga,pintar) is
	begin
		if rising_edge(clk_vga) then
			if pintar = '1' then
			
				if(0 < column and column < 160) then
				--if (row >0 and row <120 and column < 639 and column >= 0) then
					vga_R <= "0000";
					vga_G <= "0000";
					vga_B <= "1111";
					
				elsif(160 <= column and column < 320) then
				--elsif (row >= 120 and row <240 and column < 639 and column >= 0) then
					vga_R <= "1111";
					vga_G <= "0000";
					vga_B <= "0000";
				
				elsif(320 <= column and column < 480) then	
				--elsif (row >= 240 and row <360 and column < 639 and column >= 0) then
					vga_R <= "0000";
					vga_G <= "1111";
					vga_B <= "0000";
					
				elsif(480 <= column and column < 640) then
				--elsif (row >= 360 and row < 480 and column < 639 and column >= 0) then
					vga_R <= "0110";
					vga_G <= "1011";
					vga_B <= "1110";
					
				else 
					vga_R <= "0000";
					vga_G <= "0000";
					vga_B <= "0000";
					
				end if;
				
			end if;
			
		end if;

	end process mostrar_pixel;
	
end architecture behavioral;