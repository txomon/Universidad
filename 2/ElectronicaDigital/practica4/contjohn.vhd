----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:19:42 10/21/2010 
-- Design Name: 
-- Module Name:    contjohn - Behavioral 
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

entity contjohn is
port(
	clk		:	in		std_logic;
	rst		:	in		std_logic;
	dir		:	in		std_logic;
	enable	:	in		std_logic;
	led		:	out	std_logic_vector(7 downto 0));
	
end contjohn;

architecture Behavioral of contjohn is
signal leds : std_logic_vector(7 downto 0);
begin

	leds <= x"00";
	contador : process (clk)
	begin
		if enable = '1' then
			if rst = '0' then 
				leds <= x"00";
				led <= "10101010" OR leds;
			else
				if rising_edge(clk) then
					if dir='1' then
						leds <= leds (6 downto 0) & leds(7);
					else
						leds <= leds (0)& leds(7 downto 1);
					end if;
				end if;
			end if;
		end if;
	end process;


end Behavioral;

