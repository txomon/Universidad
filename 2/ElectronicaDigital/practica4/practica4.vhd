----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:00:48 10/20/2010 
-- Design Name: 
-- Module Name:    practica4 - Behavioral 
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


entity Placa is
  port (
    mclk : in  std_logic;                      -- reloj del sistema
    btn  : in  std_logic_vector(3 downto 0);   -- botones
    swt  : in  std_logic_vector(7 downto 0);   -- interruptores
    led  : out std_logic_vector(7 downto 0);   -- leds
    an   : out std_logic_vector(3 downto 0);   -- anodos display
    ssg  : out std_logic_vector(7 downto 0));  -- 7 segmentos
end Placa;
	
	
architecture Behavioral of Placa is	

COMPONENT contjohn
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		dir : IN std_logic;
		enable : IN std_logic;          
		led : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
	
COMPONENT contbcd
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		dir : IN std_logic;
		enable : IN std_logic;          
		ssg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

signal enable,rst,clk,dir	:	std_logic;
signal contador				:	std_logic_vector(25 downto 0);

begin
	enable <= swt(0);	-- 1 si 0 no
	rst <= btn(0);
	dir <= swt(1); 	-- 1 para arriba 0 para abajo
	
	process(mclk)
	begin
		contador <= contador+1;
		clk <= contador(25);
	end process;
	
		
		cont1 : contjohn
		port map (
			clk => clk,
			led => led,
			rst => rst,
			dir => dir,
			enable => enable
		);

		cont2 : contbcd
		port map (
			clk => clk,
			ssg => ssg,
			rst => rst,
			dir => dir,
			enable => enable
		);



end Behavioral;

