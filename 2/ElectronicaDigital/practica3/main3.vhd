----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:39:58 10/14/2010 
-- Design Name: 
-- Module Name:    main3 - Behavioral 
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
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity entidad is
  port (
    mclk : in  std_logic;                      -- reloj del sistema
    btn  : in  std_logic_vector(3 downto 0);   -- botones
    swt  : in  std_logic_vector(7 downto 0);   -- interruptores
    led  : out std_logic_vector(7 downto 0);   -- leds
    an   : out std_logic_vector(3 downto 0);   -- anodos display
    ssg  : out std_logic_vector(7 downto 0));  -- 7 segmentos
end entidad;

architecture Behavioral of entidad is

signal entrada1, entrada2 : std_logic_vector(2 downto 0);
signal opcion1, opcion0, salida : std_logic_vector(3 downto 0);
signal mux : std_logic;

begin

entrada1(0)<=swt(0);
entrada1(1)<=swt(1);
entrada1(2)<=swt(2);
entrada2(0)<=swt(4);
entrada2(1)<=swt(5);
entrada2(2)<=swt(6);
mux<=swt(7);



suma : entity work.sumador
port map (
   a => entrada1,
	b => entrada2,
	suma => opcion0
);

opcion1<= ('0'&entrada1) and ('0'&entrada2);
			
with mux select
salida <= opcion0 when '1',
			opcion1 when others;


    with salida SELect
   ssg<= "01111001" when "0001",   --1
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
         "10100001" when "1101",   --d
         "10000110" when "1110",   --E
         "10001110" when "1111",   --F
         "01000000" when others;   --0

		

an <= "1000";
led <= swt;


  
end Behavioral;


