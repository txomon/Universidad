----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:01:09 10/21/2010 
-- Design Name: 
-- Module Name:    contbcd - Behavioral 
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

entity contbcd is
Port ( 
		clk		: in		STD_LOGIC;
		rst		: in		STD_LOGIC;
		dir		: in		STD_LOGIC;
		enable	: in		STD_LOGIC;
		bcd		: out		STD_LOGIC_vector(3 downto 0));
end contbcd;

architecture Behavioral of contbcd is



signal numero : std_logic_vector(3 downto 0);

begin


	process(clk) is
	begin
		if rising_edge(clk) then
			if enable ='1' then
				if rst = '0' then
					if dir ='1' then
						if numero="1001" then
							numero<="0000";
						else	
							numero<=numero+1;
						end if;
					else
						if numero="0000" then
							numero<="1001";
						else
							numero<= numero -1;
						end if;
					end if;
					else
						numero<="0000";
				end if;
			end if;
		end if;
	end process;
	
bcd <= numero;


	

end Behavioral;

