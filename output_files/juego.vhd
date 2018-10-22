library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity print is
	PORT(
		clk_vga					:	in STD_LOGIC;
		x, y						:	in INTEGER;
		vga_R, vga_G,vga_B	:	out STD_LOGIC_VECTOR(3 downto 0);
		HS, VS					:	out STD_LOGIC := '0'
	);
end;
 
architecture behavioral of print is

-- Proceso para mostrar en la pantalla el pixel que queremos 
	-- con el color deseado
	mostrar_pixel:	process (vgaCLK) is

	begin
		if rising_edge(vgaCLK) then
			
			if (0<row and row <= v_video/3 and column<h_video and column > 0) then
				vga_R <= "0000";
				vga_G <= "0000";
				vga_B <= "1111";
			
			elsif (v_video/3<row and row <= 2*v_video/3 and column<h_video and column > 0) then
				vga_R <= "1111";
				vga_G <= "0000";
				vga_B <= "0000";
			
			elsif (2*v_video/3<row and row <= v_video and column<h_video and column > 0) then
				vga_R <= "0000";
				vga_G <= "1111";
				vga_B <= "0000";
				
			else 
				vga_R <= "0000";
				vga_G <= "0000";
				vga_B <= "0000";
				
			end if;
			
		end if;

	end process mostrar_pixel;
	
	--