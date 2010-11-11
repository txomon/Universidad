----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:47:47 11/11/2010 
-- Design Name: 
-- Module Name:    cambio_estado - Behavioral 
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

entity cambio_estado is
port(
	clk : in std_logic;
	actual : in std_logic_vector(3 downto 0);
	siguiente : out std_logic_vector(3 downto 0));
end cambio_estado;

architecture Behavioral of cambio_estado is

begin
process (clk) is
	begin
		if rising_edge(clk) then
			siguiente <= actual;
		end if;
	end process;
end Behavioral;

