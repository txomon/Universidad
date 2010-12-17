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
signal lento, camb_lento, cambio_display		:	integer;

---------------------------------------------------------------
------------ Variables de las Entradas-------------------------
signal rst,conf_min,conf_hora,cmb_hora,cmb_desp			: std_logic;

---------------------------------------------------------------
------------ Registros ----------------------------------------

signal hora_desp, minuto_desp		: integer;
signal hora, minuto, segundo		: integer;

---------------------------------------------------------------
------------ Señales intermedias ------------------------------
signal alarmita, enable_m, enable_h, camb_lent			: std_logic;
signal enable_minuto, enable_hora, alarma					: std_logic;
signal digito														: std_logic_vector (7 downto 0);

---------------------------------------------------------------
------------ Salidas ------------------------------------------
signal mux_camb_hra, mux_camb_min, despertador_programado					: std_logic;
signal mux_camb_desp_min,mux_camb_desp_hora , mux_display, enable_lento : std_logic;

---------------------------------------------------------------
------------ Estados-------------------------------------------

type estados is (inicio, reset, est_hora, est_desp, cmb_min, cmb_hra, cmb_desp_hra, cmb_desp_min);
signal estado_actual, estado_siguiente : estados;
---------------------------------------------------------------
------------------- señales para el display -------------------
type 4digitos is array integer range 0 to 3;
signal digito 		: 4digitos;
signal digito_ssg : integer;

begin
---------------------------------------------------------------
------------------------ Entradas------------------------------
cmb_hora		<=	swt(0);
cmb_desp		<=	swt(1);
rst 			<=	btn(0);
conf_hora	<= btn(3);
conf_min 	<= btn(2);


---------------------------------------------------------------
-----  Paso 1: Cambio de estado_actual a estado_ siguiente ----
process( mclk )
begin
	if rising_edge(mclk) then
		estado_actual <= estado_siguiente;
		
----------------------------------		
			if cambio_display = 0 then
				cambio_display<=cambio_display+1;
				an<="0111";
				digito_ssg=digito(0);
			elsif cambio_display = 250000 then
				cambio_display<=cambio_display+1;
				an<="1011";
				digito_ssg=digito(1);
			elsif cambio_display = 500000 then
				cambio_display<=cambio_display+1;
				an<="1101";
				digito_ssg=digito(2);
			elsif cambio_display = 750000 then
				cambio_display<=cambio_display+1;
				an<="1110";
				digito_ssg=digito(3);
			elsif cambio_display = 999999 then
				cambio_display <= 0;
				digito_ssg=digito(1);
			else
				cambio_display <= cambio_display+1;
			end if;
----------------------------------			
		
			if enable_lento=1 then
				if cambio_lento=24999999 then
					cambio_lento<=0;
				end if;
			else
				cambio_lento<=0;
			end if
	end if;
end process;


---------------------------------------------------------------
----- Paso 2: estado_sigiente=f(estado_actual,entradas) -------
process ( rst,conf_min,conf_hora,cmb_hora,cmb_desp,estado_actual )
begin
	case estado_actual is
		
		when reset =>			
			enable_lento <= '1';
			despertador_programado <='0';
			if rst='1' then
				estado_siguiente <= reset;
			else
				estado_siguiente <= inicio;
			end if;
			
		when inicio =>
			if cmb_hora='1' and cmb_desp='0' and rst='0' then
				enable_lento <= '0';
				estado_siguiente <= est_hora;
			elsif cmb_hora='0' and cmb_desp='1' and rst='0' then
				estado_siguiente <= est_desp;
			elsif rst='1' then
				estado_siguiente <= reset;
			else
				estado_siguiente <= inicio;
			end if;
		---------------------------------------------	
			when est_hora =>
				mux_camb_hra <='0';
				mux_camb_min <='0';
				if conf_hora='1' and conf_min='0' and rst='0' and cmb_hora='1' then
					estado_siguiente <= cmb_hra;
				elsif conf_hora='0' and conf_min='1' and rst='0' and cmb_hora='1' then
					estado_siguiente <= cmb_min;
				elsif cmb_hora='0' and rst='0' then
					enable_lento <= '1';
					estado_siguiente <= inicio;
				elsif rst='1' then
					estado_siguiente <= reset;
				else
					estado_siguiente <= est_hora;
				end if;
				---------------------------------------------
				when cmb_hra =>
					mux_camb_hra <='1';
					if conf_hora <='1' and cmb_hora='1' and rst='0' then
						estado_siguiente <= cmb_hra;
					elsif cmb_hora='0' and rst='0' then
						enable_lento <= '1';
						estado_siguiente <= inicio;
					elsif rst='1' then
						estado_siguiente<=reset;
					else
						estado_siguiente <= est_hora;
					end if;
				
				when cmb_min =>
					mux_camb_min <='1';
					if conf_min <='1' and cmb_hora='1' and rst='0' then
						estado_siguiente <= cmb_min;
					elsif cmb_hora='0' and rst='0' then
						enable_lento <= '1';
						estado_siguiente <= inicio;
					elsif rst='1' then
						estado_siguiente<=reset;
					else
						estado_siguiente <= est_hora;
					end if;
				---------------------------------------------
			when est_desp =>
				mux_display <='1';
				mux_camb_desp_hora <='0';
				mux_camb_desp_min <='0';
				if conf_hora='1' and conf_min='0' and rst='0' and cmb_desp='1' then
					estado_siguiente <= cmb_desp_hra;
				elsif conf_hora='0' and conf_min='1' and rst='0' and cmb_desp='1' then
					estado_siguiente <= cmb_desp_min;
				elsif cmb_desp='0' and rst='0' then
					estado_siguiente <= inicio;
				elsif rst='1' then
					estado_siguiente <= reset;
				else
					estado_siguiente <= est_desp;
				end if;
				---------------------------------------------
				when cmb_desp_hra =>
					mux_camb_desp_hora <='1';
					despertador_programado <='1';
					if conf_min='1' and cmb_hora='1' and rst='0' then
						estado_siguiente <= cmb_desp_min;
					elsif cmb_hora='0' and rst='0' then
						estado_siguiente <= inicio;
					elsif rst='1' then
						estado_siguiente <= reset;
					else
						estado_siguiente <= est_desp;
					end if;
					
				when cmb_desp_min =>
					mux_camb_desp_min <='1';
					despertador_programado <='1';
					if conf_min='1' and cmb_desp='1' and rst='0' then
						estado_siguiente <= cmb_desp_min;
					elsif cmb_desp='0' and rst='0' then
						estado_siguiente <= inicio;
					elsif rst='1' then
						estado_siguiente<=reset;
					else
						estado_siguiente <= est_desp;
					end if;
				---------------------------------------------
			end case;
end process;

end Behavioral;