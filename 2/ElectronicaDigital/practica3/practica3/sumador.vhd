----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:57:48 10/14/2010 
-- Design Name: 
-- Module Name:    sumador - Behavioral 
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

entity sumador is
port(
 a : in std_logic_vector (2 downto 0);
 b : in std_logic_vector (2 downto 0);
 suma : out std_logic_vector (3 downto 0));
end sumador;

architecture Behavioral of sumador is

begin

suma <= ('0'&a) + ('0'&b);

end Behavioral;

