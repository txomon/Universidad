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
  signal a, b, c ,d   : std_logic;        -- entradas
  -- salidas de los 7 apartados
  signal resultados : std_logic_vector(4 downto 1);
  -- señales intermedias para los tres últimos apartados
  signal h, i, j    : std_logic_vector(1 downto 0);
  
  signal num1,num2  : std_logic_vector(3 downto 0);


begin

-- definimos las entradas de 2 numeros de 4 bits atraves de switches
num1(0) <= swt(0);
num1(1) <= swt(1);
num1(2) <= swt(2);
num1(3) <= swt(3);
num2(0) <= swt(4);
num2(1) <= swt(5);
num2(2) <= swt(6);
num2(3) <= swt(7);


a <= btn(3);
b <= btn(2);
c <= btn(1);
d <= btn(0);

-- Creamos la tabla de verdad del enunciado para que salga por el led 0
with btn select
resultados(1) <=
'1' when "0000",
'1' when "0010",
'1' when "0100",
'1' when "0111",
'1' when "1000",
'1' when "1010",
'X' when "0101",
'X' when "1110",
'0' when others;

-- Hemos simplificado la ecuación y da /a/c/d +/b/c/d+/bc/d+/abcd

resultados(2) <= (not(a)and not(c) and not(d)) or (not(b) and not(c) and not(d)) or (not(b) and c and not(d)) or (not(a) and b and c and d);

-- ahora hacemos las operaciones de mayor menor e igual poniendo solo 2 bits de salida

resultados(3) <= '1' when num2=num1 else '1' when num1>num2 else '0';
resultados(4) <= '1' when num2=num1 else '1' when num2>num1 else '0'; 



-- LEDs: Los resultados con un cero concatenado (octavo valor)
led <= "0000"&resultados;


-- 7 segmentos apagados
an  <= X"F";                -- asignacion de valor hexadecimal
ssg <= (others => '1');     -- todos a un valor '1'


end Behavioral;

