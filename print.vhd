library IEEE;
use IEEE.STD_Logic_1164.all;
USE ieee.numeric_std.ALL; 

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

component random is
	Port (
			clk : in STD_LOGIC;
			en : in STD_LOGIC;
			random_number : out STD_LOGIC_VECTOR (8 downto 0)
	);
end component;
--

-- Resolucion de la imagen de salida
constant h_video	:	INTEGER := 640;	-- pixeles horizontales
constant v_video	:	INTEGER := 480;	-- pixeles verticales
constant tam		:	INTEGER := 30;		-- Tamaño de la nave 30x30
constant radio_asteroide : INTEGER := 5;
constant distancia : INTEGER := 60;		-- distancia vertical entre cada asteroide
													-- Esta distancia se esocgio para que aparecieran uniformemente.

type imagen30 is array (0 to 899) of STD_LOGIC_vector(11 downto 0);
constant vector_nave : imagen30 := 
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

--- Desplazamiento en X y Y para mover la nave
signal despX	: INTEGER range -1 to 640:=305; -- Valores iniciales para posicionar la nave justo en el centro de la
signal despY	: INTEGER range -1 to 480:=100; -- parte inferior de la pantalla cuando se inicia el juego

-- Definimos las señales que nos inidicaran el desplazamiento en Y de los asteroides
-- Esta desplazamiento está dado por la señal de reloj de 25 Hz
signal desp_asteroide0 : integer range -1 to 480 := 0;
signal desp_asteroide1 : integer range -1 to 480 := 0;
signal desp_asteroide2 : integer range -1 to 480 := 0;
signal desp_asteroide3 : integer range -1 to 480 := 0;
signal desp_asteroide4 : integer range -1 to 480 := 0;
signal desp_asteroide5 : integer range -1 to 480 := 0;
signal desp_asteroide6 : integer range -1 to 480 := 0;
signal desp_asteroide7 : integer range -1 to 480 := 0;

-- Posicion en X de los asteroides, que será aleaotoria
signal posX_asteroide0 : integer range 0 to 640 := 0;
signal posX_asteroide1 : integer range 0 to 640 := 0;
signal posX_asteroide2 : integer range 0 to 640 := 0;
signal posX_asteroide3 : integer range 0 to 640 := 0;
signal posX_asteroide4 : integer range 0 to 640 := 0;
signal posX_asteroide5 : integer range 0 to 640 := 0;
signal posX_asteroide6 : integer range 0 to 640 := 0;
signal posX_asteroide7 : integer range 0 to 640 := 0;

-- posX_asteroide y desp_asteroide, serán las coordenadas del centro de cada
-- asteroide, el cual lo representamos con un círculo

--- Banderas que nos indican si los contadores en X e Y entran en el rango válido
-- de cada uno de los elementos. Ya sea la nave o el asteroide
signal nave_vali	: std_logic := '0';
signal ast_vali0	: std_logic := '0';
signal ast_vali1	: std_logic := '0';
signal ast_vali2	: std_logic := '0';
signal ast_vali3	: std_logic := '0';
signal ast_vali4	: std_logic := '0';
signal ast_vali5	: std_logic := '0';
signal ast_vali6	: std_logic := '0';
signal ast_vali7	: std_logic := '0';
-- Este ultimo es para hacer un OR con todas las anteriores ya que sólo basta con que
-- una de las banderas de los asteroides se active para mandar la señal del color al vga
signal asteroide_valido	: std_logic := '0';

--- Señal de reloj a 25H para el movimiento de la nave y asteroides
signal clk25	: STD_LOGIC := '0';

-- Señal que se le envía al VGA
signal vga_color : STD_LOGIC_VECTOR(11 downto 0):= x"000";

-- Color de cada pixel de que define a la nave
signal color_nave : STD_LOGIC_VECTOR(11 downto 0) := x"000";

-- Numero Random para la posicion en x de los asteroides
signal numero_random : std_logic_vector (8 downto 0);
shared variable gen_random		: std_logic := '0';  -- Bandera que se activa cuando se quiere generar un numero random
																	-- Es de tipo variable para que cambia su valor al instante y no se espere
																	-- hasta que finalice el proceso, de esta manera se genera el numero random
																	-- de manera inmediata


begin
	
	-- Mapeamos nuestra entiendad 
	generar_random : random port map(clk_vga,gen_random,numero_random);

	-- Divisor de frecuencia a 25 Hz (Al principio eran 25 Hz, ahorita no sé :v)
	divisor25 : process(clk_vga) is
		variable cuenta : INTEGER range 0 to 100000 := 0;
	begin
		if rising_edge(clk_vga) then
			if cuenta = 100000 then
				cuenta := 0;
				clk25 <= not(clk25);
			else
				cuenta := cuenta + 2;
			end if;
		end if;
	end process divisor25;
	--
	
	-- Este proceso Aumenta o decrementa los contadores en X e Y que definen el rango 
	-- en el cual se mostrará la nave. Deshabilitamos U y D porque no nos quedó :v
	mover_nave : process (clk25,L,R, U,D) is 
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
			
			-- Bordes
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
	end process mover_nave;
	--
	
	-- Este proceso Detecta cuando el contador en Y (desp_asteroide) de cada asteroide ha llegado hasta
	-- abajo (499), si es así entonces activa la señal para generar un numero aleatorio y lo asigna a la posicion
	-- en X (posX_asteroide) del asteroide en cuestión. Así cuando vuelva a aparecer en la parte superior su posicion
	-- en X será aleatoria
	posicionar_asteroide : process (desp_asteroide0,desp_asteroide1,desp_asteroide2,desp_asteroide3,desp_asteroide4,desp_asteroide5,desp_asteroide6,desp_asteroide7) is
	begin
		
		-- Ocupamos elsif y no if independientes porque los asteroides van un tras otro, entonces
		-- no se puede dar el caso en el que dos o más lleguen al fondo al mismo tiempo, ya que los
		-- contadores en Y de cada uno están desplazados lo que indica la constante 'distancia'
		if desp_asteroide0 = 479 then
			gen_random := '1';
			posX_asteroide0 <= to_integer(unsigned(numero_random));

		elsif desp_asteroide1 = 479 then
			gen_random := '1';
			posX_asteroide1 <= to_integer(unsigned(numero_random));
		
		elsif desp_asteroide2 = 479 then
			gen_random := '1';
			posX_asteroide2 <= to_integer(unsigned(numero_random));

		elsif desp_asteroide3 = 479 then
			gen_random := '1';
			posX_asteroide3 <= to_integer(unsigned(numero_random));

		elsif desp_asteroide4 = 479 then
			gen_random := '1';
			posX_asteroide4 <= to_integer(unsigned(numero_random));

		elsif desp_asteroide5 = 479 then
			gen_random := '1';
			posX_asteroide5 <= to_integer(unsigned(numero_random));

		elsif desp_asteroide6 = 479 then
			gen_random := '1';
			posX_asteroide6 <= to_integer(unsigned(numero_random));

		elsif desp_asteroide7 = 479 then
			gen_random := '1';
			posX_asteroide7 <= to_integer(unsigned(numero_random));
			
		-- Si ninguno de los asteroides ha llegado al fondo entonces
		-- apagamos la bandera de los numero aleatorios 
		else
			gen_random := '0';
		end if;
		
	end process posicionar_asteroide;
	--
	
	-- Proceso que aumenta el contador en Y de cada asteroide por cada ciclo de reloj de '25 Hz'
	-- varifica que si se ha llegado al fondo el contador se reinicie. Además, asegura que cada contador
	-- no empiece su cuenta hasta que el contador del asteroide anterior haya llegada a la distancia de
	-- separación que se le indico en la constante 'distancia'
	mover_asteroide : process(clk25) is
	begin
		if rising_edge(clk25) then			
			
			if desp_asteroide0 = 479 then
				desp_asteroide0 <= 0;
			else
				desp_asteroide0 <= desp_asteroide0+1;
			end if;

			if desp_asteroide1 = 479 or (desp_asteroide0<distancia and desp_asteroide1=0)then
				desp_asteroide1 <= 0;
			else
				desp_asteroide1 <= desp_asteroide1+1;
			end if;
			
			if desp_asteroide2 = 479 or (desp_asteroide1<distancia and desp_asteroide2=0) then
				desp_asteroide2 <= 0;
			else
				desp_asteroide2 <= desp_asteroide2+1;
			end if;

			if desp_asteroide3 = 479 or (desp_asteroide2<distancia and desp_asteroide3=0) then
				desp_asteroide3 <= 0;
			else
				desp_asteroide3 <= desp_asteroide3+1;
			end if;

			if desp_asteroide4 = 479 or (desp_asteroide3<distancia and desp_asteroide4=0) then
				desp_asteroide4 <= 0;
			else
				desp_asteroide4 <= desp_asteroide4+1;
			end if;

			if desp_asteroide5 = 479 or (desp_asteroide4<distancia and desp_asteroide5=0) then
				desp_asteroide5 <= 0;
			else
				desp_asteroide5 <= desp_asteroide5+1;
			end if;

			if desp_asteroide6 = 479 or (desp_asteroide5<distancia and desp_asteroide6=0) then
				desp_asteroide6 <= 0;
			else
				desp_asteroide6 <= desp_asteroide6+1;
			end if;

			if desp_asteroide7 = 479 or (desp_asteroide6<distancia and desp_asteroide7=0) then
				desp_asteroide7 <= 0;
			else
				desp_asteroide7 <= desp_asteroide7+1;
			end if;
			
		end if;
	end process mover_asteroide;
	--
	
	-- Contador que nos va idicando en que posicion del arreglo de la nave colocarnos
	-- de acuerdo al ciclo de reloj de 25 MHz y le asignamos el valor hexadecimal de esa 
	-- posicion a 'color_nave' para que esta se la mande al vga
	contador_nave : process (clk_vga, nave_vali) is
		variable contador : integer range -1 to 900 := -1;
	begin
		if rising_edge(clk_vga) then
			if nave_vali = '1' then
				contador := contador+1;
				if contador = 899 then
					contador := -1;
				end if;
			end if;
		end if;
		color_nave <= vector_nave(contador);
	end process contador_nave;
	--
	
	-- Proceso para mostrar en la pantalla el pixel que queremos con el color deseado
	mostrar_pixel:	process (clk_vga,pintar,color_nave,asteroide_valido) is
	begin
		if rising_edge(clk_vga) then
			if pintar = '1' then
			
				if nave_vali = '1' and color_nave /= x"000" then
					-- Agreamos la condicion color_nave /= x"000" para que no se muestre todo
					-- el recuadro que contiene a la imagen de la nave, si detecta el negro entonces
					-- que mejor se muestre el background.
						vga_color <= color_nave;
					
				elsif asteroide_valido = '1' then
					vga_color <= x"FFF";
					
				else
					vga_color <= x"000";
				end if;
			end if;	
		end if;
	end process mostrar_pixel;
	--
	
	--nave_vali <= '1' when (column > despX and column < despX+tam+1 and row > despY and row < despY+tam+1) else '0';
	nave_vali <= '1' when (column > despX and column < despX+tam+1 and row > v_video-tam-1 and row <= v_video-1) else '0';
	
	-- Definimos los asteroides que apareceran en la pantalla. Seran 8.
	-- Los definimos a partir de la ecuacion canónica de la circunferencia.
	-- Es por eso que es importante definir bien los centros 
	ast_vali0 <= '1' when ((row-desp_asteroide0)**2 + (column-posX_asteroide0)**2 < radio_asteroide**2) else '0';
	ast_vali1 <= '1' when ((row-desp_asteroide1)**2 + (column-posX_asteroide1)**2 < radio_asteroide**2) else '0';
	ast_vali2 <= '1' when ((row-desp_asteroide2)**2 + (column-posX_asteroide2)**2 < radio_asteroide**2) else '0';
	ast_vali3 <= '1' when ((row-desp_asteroide3)**2 + (column-posX_asteroide3)**2 < radio_asteroide**2) else '0';
	ast_vali4 <= '1' when ((row-desp_asteroide4)**2 + (column-posX_asteroide4)**2 < radio_asteroide**2) else '0';
	ast_vali5 <= '1' when ((row-desp_asteroide5)**2 + (column-posX_asteroide5)**2 < radio_asteroide**2) else '0';
	ast_vali6 <= '1' when ((row-desp_asteroide6)**2 + (column-posX_asteroide6)**2 < radio_asteroide**2) else '0';
	ast_vali7 <= '1' when ((row-desp_asteroide7)**2 + (column-posX_asteroide7)**2 < radio_asteroide**2) else '0';
	
	asteroide_valido <= ast_vali0 or ast_vali1 or ast_vali2 or ast_vali3 or ast_vali4 or ast_vali5 or ast_vali6 or ast_vali7;
	
	vga_R <= vga_color(11 downto 8);
	vga_G <= vga_color(7 downto 4);
	vga_B <= vga_color(3 downto 0);
	
end architecture behavioral;