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

architecture Behavioral of practica4 is
signal enable,rst,clk,dir : std_logic;

begin
	enable <= swt(0);
	rst <= btn(0);
	dir <= swt(1);
	
	clk : process(mclk)
	begin
		clk <= not(clk);
		wait for 1s;
	end process;

	mux : process(enable)
	begin
		if enable = 0 then		
			contjohn : contjohn
			port map (
				clk => clk,
				led => led,
				rst => rst,
				dir => dir
			);
		else
			contbsd : contbsd
			port map (
				clk => clk,
				ssg => ssg,
				rst => rst,
				dir => dir
			);
		end if;
	end process;

end Behavioral;

