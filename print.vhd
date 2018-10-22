library IEEE;
use IEEE.STD_Logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

-- Revisar el desplazamiento vertical,ya que no se muestra bien la imagen
-- Parace que es causado cuando U= '1' o D='1' porque se debe resetear la imagen
-- Cuando se desplaza hacia arriba o hacia abajo


entity print is
	PORT(
		clk_vga					:	in STD_LOGIC;
		column, row				:	in INTEGER;
		vga_R, vga_G,vga_B	:	out STD_LOGIC_VECTOR(3 downto 0);
		pintar					:	in	STD_LOGIC;
		L, R, U, D			:	in STD_LOGIC
	);
end;
 
architecture behavioral of print is

-- Resolucion de la imagen de salida
constant h_video	:	INTEGER := 640;	-- pixeles horizontales
constant v_video	:	INTEGER := 480;	-- pixeles verticales
constant tam		:	INTEGER := 30;		-- Tamaño de la nave 30x30

type imagen30 is array (0 to 899) of STD_LOGIC_vector(11 downto 0);
constant nave : imagen30 := 
(
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"100",x"000",x"000",x"000",x"000",x"100",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"001",x"001",x"001",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"012",x"123",x"123",x"012",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"112",x"123",x"123",x"012",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"112",x"123",x"123",x"012",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"112",x"123",x"123",x"012",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"112",x"123",x"123",x"112",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"211",x"322",x"322",x"211",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"211",x"321",x"321",x"211",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"100",x"211",x"211",x"221",x"321",x"321",x"221",x"211",x"211",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"100",x"321",x"321",x"321",x"331",x"331",x"321",x"321",x"211",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"100",x"321",x"321",x"321",x"331",x"331",x"321",x"321",x"211",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"100",x"321",x"321",x"321",x"331",x"331",x"321",x"321",x"211",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"100",x"321",x"321",x"321",x"331",x"331",x"321",x"321",x"311",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"112",x"112",x"012",x"000",x"100",x"321",x"321",x"321",x"331",x"331",x"321",x"321",x"211",x"000",x"000",x"012",x"112",x"012",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"001",x"123",x"123",x"122",x"000",x"100",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"000",x"001",x"123",x"123",x"123",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"001",x"123",x"123",x"122",x"100",x"100",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"000",x"101",x"123",x"123",x"123",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"001",x"123",x"123",x"222",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"311",x"211",x"211",x"123",x"123",x"122",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"001",x"123",x"123",x"223",x"211",x"311",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"223",x"123",x"123",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"110",x"211",x"211",x"222",x"223",x"222",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"222",x"223",x"222",x"211",x"211",x"100",x"000",x"000",x"000",
	x"000",x"000",x"000",x"211",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"211",x"000",x"000",x"000",
	x"000",x"100",x"100",x"211",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"211",x"100",x"100",x"000",
	x"100",x"311",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"311",x"311",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"000",
	x"110",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"000",
	x"110",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"311",x"100",
	x"100",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"311",x"100",
	x"100",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"321",x"321",x"321",x"321",x"321",x"311",x"000",
	x"100",x"211",x"211",x"211",x"211",x"211",x"211",x"211",x"211",x"110",x"211",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"311",x"110",x"110",x"211",x"211",x"211",x"211",x"211",x"211",x"211",x"211",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"100",x"321",x"321",x"321",x"211",x"211",x"321",x"321",x"311",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",
	x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"100",x"211",x"321",x"211",x"211",x"211",x"311",x"321",x"211",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000",x"000"
);
--


--- Señal de reloj a 25H para el movimiento de la nave -----
signal clk25	: STD_LOGIC := '0';

--- Desplazamiento en X y Y para mover la figura ----
signal despX	: INTEGER range -1 to 640:=0;
signal despY	: INTEGER range -1 to 480:=0;

signal vga_color : STD_LOGIC_VECTOR(11 downto 0):= x"000";
signal color_nave : STD_LOGIC_VECTOR(11 downto 0) := x"000";

--- Saber si se puede o no mostrar la nave ---
signal nave_vali : std_logic := '0';

begin

	divisor25 : process(clk_vga) is
		variable cuenta : INTEGER range 0 to 1000000 := 0;
	begin
		if rising_edge(clk_vga) then
			if cuenta = 1000000 then
				cuenta := 0;
				clk25 <= not(clk25);
			else
				cuenta := cuenta + 10;
			end if;
		end if;
	end process divisor25;
	--
	
	mover_figura : process(clk25,L,R, U,D) is
		---- Variable que nos dice si el objeto se mueve hacia arriba o abajo
		-- O haceia la izquierda o derecha
		variable sentidoX :	INTEGER range -1 to 1 := 1;
		variable sentidoY :	INTEGER range -1 to 1 := 1;
	begin
		if rising_edge(clk25) then
			if L = '1' then
				despX <= despX - 1;
			end if;
			if R = '1' then
				despX <= despX + 1;
			end if;
			
			if U = '1' then
				despY <= despY - 1;
			end if;
			if D = '1' then
				despY <= despY + 1;
			end if;
			
			if despX = h_video-tam-1 then
				despX <= h_video-tam-2;
			elsif despX = 0 then
				despX <= 1;
			end if;
			
			if despY = v_video-tam-1 then
				despY <= v_video-tam-2;
			elsif despY = 0 then
				despY <= 1;
			end if;
			
		end if;
	end process mover_figura;
	--
	
	conta : process (clk_vga, pintar, nave_vali,U,D) is
		variable contador : integer range -1 to 900 := -1;
	begin
		if rising_edge(clk_vga) then
			if pintar = '1' and nave_vali = '1' then
				contador := contador+1;
				-- Aqui es la falla
				if (contador = 899 or U='1' or D='1') then
					contador := -1;
				end if;
			end if;
		end if;
		color_nave <= nave(contador);
	end process conta;
	--
	
	-- Proceso para mostrar en la pantalla el pixel que queremos 
	-- con el color deseado
	mostrar_pixel:	process (clk_vga,pintar,despX,despY, row, column,color_nave) is
		variable cont : integer range 0 to 900 := 899;
	begin
		if rising_edge(clk_vga) then
			if pintar = '1' then
				if nave_vali = '1' then
					vga_color <= color_nave;	
				else
					vga_color <= x"000";
				end if;
			end if;	
		end if;
	end process mostrar_pixel;
	--
	nave_vali <= '1' when (column > despX and column < despX+tam+1 and row > despY and row < despY+tam+1) else '0';
	vga_R <= vga_color(11 downto 8);
	vga_G <= vga_color(7 downto 4);
	vga_B <= vga_color(3 downto 0);
	
end architecture behavioral;