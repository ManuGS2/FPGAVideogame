library IEEE;
use IEEE.STD_Logic_1164.all;

entity video_sincronizacion is
	PORT(
		clk_vga	:	in STD_LOGIC;
		x, y		:	out INTEGER;
		HS, VS	:	out STD_LOGIC := '0';
		display	:	out STD_LOGIC := '0'
	);
end;

architecture Behavioral of video_sincronizacion is

-- Resolucion de la imagen de salida
constant h_video	:	INTEGER := 640;	-- pixeles horizontales
constant v_video	:	INTEGER := 480;	-- pixeles verticales

-- Sincronización horizontal
constant h_blank 	:	INTEGER := 96;		-- blank horizontal
constant h_backP 	:	INTEGER := 144;	-- back porch 144-96=48
constant h_frontP	:	INTEGER := 16;		-- front porch
constant h_cycle	:	INTEGER := 800; 	-- ciclo horizontal

-- Sincronización vertical
constant v_blank 	:	INTEGER := 2;		-- blank vertical
constant v_backP 	:	INTEGER := 35;		-- back porch 35-2 = 33
constant v_frontP	:	INTEGER := 10;		-- front porch
constant v_cycle	:	INTEGER := 525; 	-- ciclo vertica

-- Contadores para el lado horizontal y el lado vertical  
signal v_cont	:	INTEGER := 0;
signal h_cont	:	INTEGER := 0;

-- Banderas que indican si podemos mostrar o no datos en la pantalla
signal h_vali, v_vali	:	STD_LOGIC := '0';


begin

	-- Contadores de pixeles verticales y horizontales
	contador	:	process (clk_vga) is
	begin
		if falling_edge(clk_vga) then
			if h_cont = h_cycle-1 then
				h_cont <= 0;
				
				if v_cont = v_cycle-1 then
					v_cont <= 0;
				else
					v_cont <= v_cont+1;
				end if;
			
			else
				h_cont <= h_cont+1;
			end if;
			
		end if;
		
	end process contador;
	--
	
	-- Asignacion de las coordenadas para X y Y 
	x <= h_cont - h_backP when (h_cont < h_cycle - h_frontP) else h_video;
	y <= v_cont - v_backP when (v_cont < v_cycle - v_frontP) else v_video;
	
	-- validación si los contadores se encuentran después 
	-- del rango de sincronización de cada fila y columna
	HS <= '0' when (h_cont < h_blank) else '1';
	VS <= '0' when (v_cont < v_blank) else '1';
	
	--Validación si los contadores se encuentran en el rango visible
	-- para poder desplegar los colores en la pantalla. Mayor que back porch y menor que front porch
	h_vali <= '1' when ((h_cont < h_cycle-h_frontP) and (h_cont>=h_backP)) else '0';
	v_vali <= '1' when ((v_cont < v_cycle-v_frontP) and (v_cont>=v_backP)) else '0';
	
	display <= h_vali and v_vali;
	
end Behavioral;