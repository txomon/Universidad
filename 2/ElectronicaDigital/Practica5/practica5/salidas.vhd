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
	actual : in std_logic_vector(3 downto 0));
end salidas;

architecture Behavioral of salidas is

begin


end Behavioral;

