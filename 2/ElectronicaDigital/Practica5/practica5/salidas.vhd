----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:48:20 11/11/2010 
-- Design Name: 
-- Module Name:    salidas - Behavioral 
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

entity salidas is
port(
	led : out std_logic_vector(7 downto 0);
	ssg : out std_logic_vector(7 downto 0);
	actual : in std_logic_vector(3 downto 0);
	num_actual :in std_logic_vector(3 downto 0));
end salidas;

architecture Behavioral of salidas is

begin
	
			--			HEX-to-seven-segment decoder
			--   HEX:   in    STD_LOGIC_VECTOR (3 downto 0);
			--   LED:   out   STD_LOGIC_VECTOR (6 downto 0);
			-- 
			-- segment encoinputg
			--      0
			--     ---  
			--  5 |   | 1
			--     ---   <- 6
			--  4 |   | 2
			--     ---
			--      3
   
		with num_actual SELect
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
				"11000000" when others;   --0
	
		with actual select
		led <= "11110000" when "0000",
				 "00111100" when "0001",
				 "00001111" when "0010",
				 "00000011" when "0011",
				 "00000000" when "1111",
				 "00001111" when "1000",
				 "00111100" when "1001",
				 "11110000" when "1010",
				 "11000000" when "1011",
				 "10101010" when others;
	
end Behavioral;

