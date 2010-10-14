----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:14:48 10/01/2010 
-- Design Name: 
-- Module Name:    practica1 - Behavioral 
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

entity practica1 is
  port (
    mclk : in  std_logic;                      -- reloj del sistema
    btn  : in  std_logic_vector(3 downto 0);   -- botones
    swt  : in  std_logic_vector(7 downto 0);   -- interruptores
    led  : out std_logic_vector(7 downto 0);   -- leds
    an   : out std_logic_vector(3 downto 0);   -- anodos display
    ssg  : out std_logic_vector(7 downto 0));  -- 7 segmentos
end practica1;

architecture Behavioral of practica1 is
  signal a, b, c    : std_logic;        -- entradas
  -- salidas de los 7 apartados
  signal resultados : std_logic_vector(7 downto 1);
  -- señales intermedias para los tres últimos apartados
  signal h, i, j    : std_logic_vector(1 downto 0);


begin
a <= btn(0);
 b <= btn(1);
 c <= btn(2);

-- Describir y simular un circuito con una sola entrada a, que realice la
-- función a · a
resultados(1) <= a and a;

-- Describir y simular un circuito con una sola entrada a, que realice la
-- función a + 1
resultados(2) <= a or '1';

-- Describir y simular un circuito con una sola entrada a, que realice la
-- funcion //a 
resultados(3) <= not(not(a));


-- Describir y simular un circuito con dos entradas a y b , que realice la
-- funcion a+a*b

resultados(4) <= a or (a and b);


-- Describir y simular un circuito con tres entradas a, b c, que realice la
-- funciones a+(b+c) y (a+b)+c
h(1) <= a or (b or c);
h(0) <= (a or b) or c;

resultados(5) <= '1' when h(0)= h(1) else '0'; -- '1' si son iguales


-- Describir y simular un circuito con dos entrada a y b, que realice las
-- funciones /(a + b) y /a · /b
i(1) <= not (a or b);
i(0) <= not (a) and not (b);

resultados(6) <= '1' when i(1) = i(0) else '0';  -- '1' si son iguales


-- Describir y simular un circuito con 3 entrada a,b,c que realice las
-- funciones /(f(a; b; c) = /a*b+b*c; y f(a; b; c) = /(a + /b) + /a*b*c + /(/c + /a + /b).
j(1) <= (not a and b) or (b and c);
j(0) <= not(a or not (b)) or (not (a) and b and c) or not(not (c) or not (a) or not (b));

resultados(7) <= '1' when j(1) = j(0) else '0';


-- LEDs: Los resultados con un cero concatenado (octavo valor)
led <= '0'&resultados;

-- 7 segmentos apagados
an  <= X"F";                -- asignacion de valor hexadecimal
ssg <= (others => '1');     -- todos a un valor '1'


end Behavioral;

