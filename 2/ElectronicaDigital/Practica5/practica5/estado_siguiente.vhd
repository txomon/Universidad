----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:48:08 11/11/2010 
-- Design Name: 
-- Module Name:    estado_siguiente - Behavioral 
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

entity estado_siguiente is

port(
	s1 : in std_logic;
	s2 : in std_logic;
	reset  : in std_logic;
	actual  : in std_logic_vector(3 downto 0);
	siguiente  : out std_logic_vector(3 downto 0));

end estado_siguiente;

architecture Behavioral of estado_siguiente is

begin
process (actual, s1, s2, reset) is
	begin
		if reset = '1' then 
			siguiente <= "1111";
		else
			case actual is 
				when "0000" =>
					if (s1='1' and s2 = '0') then
						siguiente <= actual;
					elsif s1='0' and s2 = '0' then
						siguiente <= "1111";
					elsif s1='1' and s2 = '1' then
						siguiente <= "0001";
					end if;
					
				when "0001" =>
					if s1='1' and s2 = '1' then
						siguiente <= actual;
					elsif s1='1' and s2 = '0' then
						siguiente <= "0000";
					elsif s1 = '0' and s2= '1' then
						siguiente <= "0010";
					end if;

				when "0010" =>
					if s1 = '0' and s2= '1' then
						siguiente <= actual;
					elsif s1 = '1' and s2 = '1' then 
						siguiente <= "0001";
					elsif s1 = '0' and s2 = '0' then
						siguiente <= "0011";
					end if;
					
				when "0011" =>
						siguiente <= "1111";
					
				when "0100" =>
					if s1 = '0' and s2 = '0' then
						siguiente <= "1111";
					elsif s1 = '0' and s2 = '1' then 
						siguiente <= actual;
					elsif s1 = '1' and s2 = '1' then 
						siguiente <= "0101";
					end if;
					
				when "0101" =>
					if s1 = '0' and s2 = '1' then 
						siguiente <= "0100";
					elsif s1 = '1' and s2 = '1' then 
						siguiente <= actual;
					elsif s1 = '1' and s2 = '0' then 
						siguiente <= "0110";
					end if;

				when "0110" =>
					if s1 = '1' and s2 = '1' then 
						siguiente <= "0101";
					elsif s1 = '1' and s2 = '0' then 
						siguiente <= actual;
					elsif s1 = '0' and s2 = '0' then
						siguiente <= "1111";
					end if;
					
				when "0111" =>
					 siguiente <= "1111"

				when "1111" =>
					if s1 = '1' and s2 = '0' then 
						siguiente <= "0000";
					if s1 = '0' and s2 = '0' then 
						siguiente <= actual;
					if s1 = '0' and s2 = '1' then 
						siguiente <= "0100"

				when others =>
					siguiente <= "1111";

			end case;
			
	
	end process;
end Behavioral;

