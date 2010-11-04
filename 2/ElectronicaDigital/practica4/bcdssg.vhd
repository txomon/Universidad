----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:14:31 10/28/2010 
-- Design Name: 
-- Module Name:    bcdssg - Behavioral 
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

entity bcdssg is

Port ( 
		bcd		: in 		STD_LOGIC_VECTOR(4 downto 1);
		ssg		: out		STD_LOGIC_vector(7 downto 0));
end bcdssg;

architecture Behavioral of bcdssg is
begin

with bcd select
	ssg(6 downto 0)<= "1111001" when "0001",   --1
							"0100100" when "0010",   --2
							"0110000" when "0011",   --3
							"0011001" when "0100",   --4
							"0010010" when "0101",   --5
							"0000010" when "0110",   --6
							"1111000" when "0111",   --7
							"0000000" when "1000",   --8
							"0010000" when "1001",   --9
							"1000000" when others;   --0
	ssg(7) <='0'; 





end Behavioral;

