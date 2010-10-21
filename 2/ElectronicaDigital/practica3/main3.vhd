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

process (salida)
begin
case salida is 
      when "0000" =>
         ssg <= "00000001";
      when "0001" =>
         ssg <= "01001111";
      when "0010" =>
         ssg <= "00010010";
      when "0011" =>
			ssg <= "00000110";
      when "0100" =>
         ssg <= "01001100";
      when "0101" =>
         ssg <= "00100100";
      when "0110" =>
         ssg <= "00100000";
      when "0111" =>
         ssg <= "01111000";
      when "1000" =>
         ssg <= "00000000"; 
      when "1001" =>
         ssg <= "00001100";
      when "1010" =>
         ssg <= "10001000";
      when "1011" =>
         ssg <= "10000000";
      when "1100" =>
         ssg <= "10110001";
      when "1101" =>
         ssg <= "10000001";
      when "1110" =>
         ssg <= "10110000";
      when "1111" =>
         ssg <= "10111000";
      when others =>
         ssg <= "11001001";
   end case;

end process;
		

an <= "1000";
led <= swt;


  
end Behavioral;


