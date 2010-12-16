----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:32:29 12/02/2010 
-- Design Name: 
-- Module Name:    despertador - Behavioral 
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

entity despertador is

  port (
    mclk : in  std_logic;                      -- reloj del sistema
    btn  : in  std_logic_vector(3 downto 0);   -- botones
    swt  : in  std_logic_vector(7 downto 0);   -- interruptores
    led  : out std_logic_vector(7 downto 0);   -- leds
    an   : out std_logic_vector(3 downto 0);   -- anodos display
    ssg  : out std_logic_vector(7 downto 0));  -- 7 segmentos

end despertador;

architecture Behavioral of despertador is
---------------------------------------------------------------
------------ Contadores ---------------------------------------
signal lento, camb_lento			:	integer;

---------------------------------------------------------------
------------ Variables de las Entradas-------------------------
signal rst,conf_min,conf_hora,cmb_hora,cmb_desp			: std_logic;

---------------------------------------------------------------
------------ Registros ----------------------------------------

signal hora_desp, minuto_desp		: integer;
signal hora, minuto, segundo		: integer;

---------------------------------------------------------------
------------ Señales intermedias ------------------------------
signal lento, alarmita, enable_m, enable_h, camb_lent : std_logic;
signal enable_minuto, enable_hora, alarma					: std_logic;
signal digito														: std_logic_vector (7 downto 0);

---------------------------------------------------------------
------------ Salidas ------------------------------------------
signal mux_camb_hora, mux_camb_min, despertador_programado					: std_logic;
signal mux_camb_desp_min,mux_camb_desp_hra , mux_display, enable_lento : std_logic;

---------------------------------------------------------------
------------ Estados-------------------------------------------

type estados is (inicio, reset, est_hora, est_desp, cmb_min, cmb_hra, cmb_desp_hra, cmb_desp_min);
signal estado_actual, estado_siguiente : estados;
---------------------------------------------------------------
begin
---------------------------------------------------------------
------------------------ Entradas------------------------------
cmb_hora		<=	swt(0);
cmb_desp		<=	swt(1);
rst 			<=	btn(0);
conf_hora	<= btn(3);
conf_minuto	<= btn(2);


---------------------------------------------------------------
-----  Paso 1: Cambio de estado_actual a estado_ siguiente ----
process( mclk )
begin
	if rising_edge(mclk) then
		estado_actual <= estado_siguiente;
	end if;
end process;


---------------------------------------------------------------
----- Paso 2: estado_sigiente=f(estado_actual,entradas) -------
process ( rst,conf_min,conf_hora,cmb_hora,cmb_desp,estado_actual )
begin
	case estado_actual is
		when reset =>
			if rst=1 then
				estado_siguiente <= reset;
			else
				estado_siguiente <= inicio;
			end if;
			
		when inicio =>
			if cmb_hora='1' and cmb_desp='0' and rst='0' then
				estado_siguiente <= est_hora;
			elsif cmb_hora='0' and cmb_desp='1' and rst='0' then
				estado_siguiente <= est_desp;
			elsif rst='1' then
				estado_siguiente <= reset;
			else
				estado_siguiente <= inicio
			end if;
		
	

end process;

end Behavioral;