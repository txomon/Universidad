----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:16:41 11/11/2010 
-- Design Name: 
-- Module Name:    principal - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity principal is
  port (
    mclk : in  std_logic;                      -- reloj del sistema
    btn  : in  std_logic_vector(3 downto 0);   -- botones
    swt  : in  std_logic_vector(7 downto 0);   -- interruptores
    led  : out std_logic_vector(7 downto 0);   -- leds
    an   : out std_logic_vector(3 downto 0);   -- anodos display
    ssg  : out std_logic_vector(7 downto 0));  -- 7 segmentos

end principal;

architecture Behavioral of principal is
signal s1,s2,reset : std_logic;
type estado is (home, entrada_1,entrada_2,entrada_3,dentro,salida_1,salida_2,salida_3,fuera); 
signal actual,siguiente : estado;
signal numero : std_logic_vector(3 downto 0);
signal lleno : std_logic;


begin

s1<= swt(0);
s2<= swt(7);
reset<= btn(0);

process (actual, s1, s2, reset)
	begin
		if reset = '1' then 
			siguiente <= home;
		else
			case actual is 
				when entrada_1 =>
					if s1='0' and s2 = '0' then
						siguiente <= home;
					elsif s1='1' and s2 = '0' then
						siguiente <= actual;
					elsif s1='1' and s2 = '1' then
						siguiente <= entrada_2;
					end if;
				
				when entrada_2 =>
					if s1='1' and s2 = '0' then
						siguiente <= entrada_1;
					elsif s1='1' and s2 = '1' then
						siguiente <= actual;
					elsif s1 = '0' and s2= '1' then
						siguiente <= entrada_3;
					end if;
	
				when entrada_3 =>
					if s1 = '1' and s2 = '1' then 
						siguiente <= entrada_2;
					elsif s1 = '0' and s2= '1' then
						siguiente <= actual;
					elsif s1 = '0' and s2 = '0' then
						siguiente <= dentro;
					end if;
					
				when dentro =>
						siguiente <= home;
											
				when salida_1=>
					if s1 = '0' and s2 = '0' then
						siguiente <= home;
					elsif s1 = '0' and s2 = '1' then 
						siguiente <= actual;
					elsif s1 = '1' and s2 = '1' then 
						siguiente <= salida_2;
					end if;
					
				when salida_2 =>
					if s1 = '0' and s2 = '1' then 
						siguiente <= salida_1;
					elsif s1 = '1' and s2 = '1' then 
						siguiente <= actual;
					elsif s1 = '1' and s2 = '0' then 
						siguiente <= salida_3;
					end if;

				when salida_3 =>
					if s1 = '1' and s2 = '1' then 
						siguiente <= salida_2;
					elsif s1 = '1' and s2 = '0' then 
						siguiente <= actual;
					elsif s1 = '0' and s2 = '0' then
						siguiente <= fuera;
					end if;
				
				when fuera =>
					siguiente <= home;

				when home =>
					if s1 = '1' and s2 = '0' then 
						siguiente <= entrada_1;
					elsif s1 = '0' and s2 = '0' then 
						siguiente <= actual;
					elsif s1 = '0' and s2 = '1' then 
						siguiente <= salida_1;
					end if;

				when others =>
					siguiente <= home;

			end case;
			
		end if;
	end process;
	
	process (mclk)
	begin
			if rising_edge(mclk) then
				actual <= siguiente;
			end if;
	end process;



	with numero select
		an <= "0000" when "1101",
				"0111" when others;


-- Control de las salidas

	
	process(actual,reset)
	begin
		if reset = '1' then
			numero <= "0000";
			lleno <= '0';
		else
			if actual = dentro then
				numero <= numero+1;
			elsif actual = fuera then
				numero <= numero-1;
			end if;
		end if;
	end process;

-- ssg indicando el número de coches
	with numero select
		ssg<= "11000000" when "0000",   --0
				 "01111001" when "0001",   --1
				 "00100100" when "0010",   --2
				 "00110000" when "0011",   --3
				 "00011001" when "0100",   --4
				 "00010010" when "0101",   --5
				 "00000010" when "0110",   --6
				 "01111000" when "0111",   --7
				 "00000000" when "1000",   --8
				 "00010000" when "1001",   --9
				 "10001000" when "1010",   --A
				 "10000011" when "1011",   --b	
				 "11000110" when "1100",   --C
				 "10001110" when "1101",   --d
				 "00000000" when others;
				 
				 
-- leds indicando el estado actual
		with actual select
		led <= "11110000" when entrada_1,
				 "00111100" when entrada_2,
				 "00001111" when entrada_3,
				 "00000011" when dentro,
				 "00000000" when home,
				 "00001111" when salida_1,
				 "00111100" when salida_2,
				 "11110000" when salida_3,
				 "11000000" when fuera,
				 "10101010" when others;



end Behavioral;

