----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:16:41 11/11/2010 
-- Design Name: 
-- Module Name:    principal - Behavioral 
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

entity principal is
  port (
    mclk : in  std_logic;                      -- reloj del sistema
    btn  : in  std_logic_vector(3 downto 0);   -- botones
    swt  : in  std_logic_vector(7 downto 0);   -- interruptores
    led  : out std_logic_vector(7 downto 0);   -- leds
    an   : out std_logic_vector(3 downto 0);   -- anodos display
    ssg  : out std_logic_vector(7 downto 0));  -- 7 segmentos

end principal;

architecture Behavioral of principal is

	COMPONENT cambio_estado
	PORT(
		clk : IN std_logic;
		actual : IN std_logic_vector(3 downto 0);          
		siguiente : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT estado_siguiente
	PORT(
		s1 : IN std_logic;
		s2 : IN std_logic;
		reset : IN std_logic;
		actual : IN std_logic_vector(3 downto 0);          
		siguiente : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;


	COMPONENT salidas
	PORT(
		actual : IN std_logic_vector(3 downto 0);          
		led : OUT std_logic_vector(7 downto 0);
		ssg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

signal s1,s2,reset : std_logic;
signal actual,siguiente : std_logic_vector(3 downto 0);

begin

s1<= swt(7);
s2<= swt(0);
reset<= btn(0);

a : cambio_estado

port map(
	clk => mclk,
	actual => actual,
	siguiente => siguiente
);

b : estado_siguiente
port map(
	s1 => s1,
	s2 => s2,
	reset => reset,
	actual => actual,
	siguiente => siguiente
);

an <= x"8";

c : salidas
port map(
	led => led,
	ssg => ssg,
	actual => actual
);

end Behavioral;

