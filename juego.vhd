library IEEE;
use IEEE.STD_Logic_1164.all;

entity juego is
	PORT(
		clk					:	in STD_LOGIC;
		Ubtn,Dbtn,Rbtn,Lbtn:	in STD_LOGIC;		
		shoot					:  in STD_LOGIC;
		btnB					:  in STD_LOGIC;
		vgaR,vgaG,vgaB		:	out STD_LOGIC_VECTOR(3 downto 0);
		hs, vs				:	out STD_LOGIC := '0';
		leds 					:	out std_logic_vector(9 downto 0)
	);
end;

architecture Behavioral of juego is

component divisor25 is
	PORT(
		clk		:	in STD_LOGIC;
		clk_vga	:	out STD_LOGIC
	);
end component;


component video_sincronizacion is
	PORT(
		clk_vga	:	in STD_LOGIC;
		x, y		:	out INTEGER;
		HS, VS	:	out STD_LOGIC;
		display	:	out STD_LOGIC
	);
end component;

component print is
	PORT(
		clk_vga				:	in STD_LOGIC;
		column, row			:	in INTEGER;
		vga_R,vga_G,vga_B	:	out STD_LOGIC_VECTOR(3 downto 0);
		pintar				:	in	STD_LOGIC;
		L, R, U, D			:	in STD_LOGIC;
		shoot					:	in STD_LOGIC;
		btnB					:  in STD_LOGIC
	);
end component;

-- Contadores para cada fila y columna
signal posX			: INTEGER := 0;
signal posY			: INTEGER := 0;
signal clkVGA 		: STD_LOGIC := '0';
signal dispVali	: STD_LOGIC := '0';


begin
	
	divisor: divisor25 port map(clk, clkVGA);
	
	video: video_sincronizacion port map(clkVGA,posX,posY,hs,vs,dispVali);
	
	print_cuadrado: print port map(clkVGA,posX,posY,vgaR,vgaG,vgaB,dispVali,Lbtn,Rbtn,Ubtn,Dbtn, shoot,btnB);

	leds(0) <= Lbtn;
	leds(1) <= Rbtn;
	leds(2) <= Ubtn;
	leds(3) <= Dbtn;
	leds(4) <= shoot;
	leds(5) <= btnB;
	

end Behavioral;