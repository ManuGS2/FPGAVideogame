-- Genera un numero semialeatorio a partir de operaciones XOR con los bits del arreglo
-- El número está entre 30 y 511 que denota la posicion en X. 30 para que el circulo
-- no se pinte justo en la orilla izquiera y 511 es el número másn grande que podemos representar
-- con 9 bits.

-- Pudimos haber ocupado 10 bits, pero entonces el número más grande sería el 1023, pero la pantalla solo
-- llega hasta 640 en X, por lo que hay mucha probabilidad de salirse del rango al escoger el numero aleatorio
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity random is
	Port (
			clk : in STD_LOGIC;
			en : in STD_LOGIC;
			random_number : out STD_LOGIC_VECTOR (8 downto 0)
	);
end random;

architecture Behavioral of random is

signal Qt: STD_LOGIC_VECTOR(8 downto 0) := "000000001";

begin

	process(en,clk) is
		variable tmp : STD_LOGIC := '0';
	begin
		if rising_edge(clk) then
			if en = '1' then
				-- Podemos elegir otros bits para hacer las XOR, pero esta combinacion es la que
				-- nos mejor se ajustó a parecer aleatorio
				tmp := Qt(8) XOR Qt(6) XOR Qt(4) XOR Qt(3) XOR Qt(2) XOR Qt(0);
				Qt <= tmp & Qt(8 downto 1);
				
				-- Si es 30 es nuestro menor número
				if Qt < "000011110" then
					Qt <= "000011110";
				end if;
			end if;
		end if;
	end process;
	
	random_number <= Qt;

end Behavioral;