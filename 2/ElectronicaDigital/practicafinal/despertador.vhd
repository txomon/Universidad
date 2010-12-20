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
signal cuenta_lento, camb_lento, cambio_display		:	integer;
signal camb_rapido											:	integer;
signal rapido, lento, minutos, segundos							:	std_logic;

---------------------------------------------------------------
------------ Señales de las Entradas-------------------------
signal rst,conf_min,conf_hora,cmb_hora,cmb_desp			: std_logic;

---------------------------------------------------------------
------------ Registros ----------------------------------------

signal hora_desp, minuto_desp		: integer;
signal hora, minuto, segundo		: integer;

---------------------------------------------------------------
------------ Señales intermedias ------------------------------
signal alarmita, enable_m, enable_h, camb_lent			: std_logic;
signal enable_min, enable_hra, alarma						: std_logic;

---------------------------------------------------------------
------------ Salidas ------------------------------------------
signal mux_camb_hra, mux_camb_min, despertador_programado					: std_logic;
signal mux_camb_desp_min, mux_camb_desp_hora , mux_display, enable_lento : std_logic;

---------------------------------------------------------------
------------ Estados-------------------------------------------

type estados is (inicio, reset, est_hora, est_desp, cmb_min, cmb_hra, cmb_desp_hra, cmb_desp_min);
signal estado_actual, estado_siguiente : estados;
---------------------------------------------------------------
------------------- señales para el display -------------------
type array_digitos is array (0 to 3) of integer;
signal digitos		: array_digitos;
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
			digito_ssg<=digitos(0);
		elsif cambio_display = 249999 then	-- Para la placa
--		elsif cambio_display = 2 then 		-- Para la simulacion
			cambio_display<=cambio_display+1;
			an<="1011";
			digito_ssg<=digitos(1);
		elsif cambio_display = 499999 then	-- Para la placa
--		elsif cambio_display = 4 then 		-- Para la simulacion
			cambio_display<=cambio_display+1;
			an<="1101";
			digito_ssg<=digitos(2);
		elsif cambio_display = 749999 then	-- Para la placa
--		elsif cambio_display = 7 then 		-- Para la simulacion
			cambio_display<=cambio_display+1;
			an<="1110";
			digito_ssg<=digitos(3);
		elsif cambio_display = 999999 then	-- Para la placa
--		elsif cambio_display = 9 then 		-- Para la simulacion
			cambio_display <= 0;
			digito_ssg<=digitos(1);
		else
			cambio_display <= cambio_display+1;
		end if;
----------------------------------			
	
		if hora = hora_desp and minuto = minuto_desp then
			alarmita<='1';
		else
			alarmita<='0';
		end if;
		
----------------------------------
		if camb_rapido=24999999 then		-- Para la placa
--		if camb_rapido=249 then				-- Para la simulación
			camb_rapido<=0;
			rapido<='1';
		else
			camb_rapido<=camb_rapido+1;
			rapido<='0';
		end if;
		
----------------------------------
		if enable_lento='1' then
			if cuenta_lento=24999999 then	-- Para la placa
--			if cuenta_lento=249 then		-- Para la simulación
				cuenta_lento<=0;
				lento<= '1';
			else
				cuenta_lento<=cuenta_lento+1;
				lento<= '0';
			end if;
		else
			lento<='0';
		end if;
		
		if rst = '0' then
			if lento='1' then 
				if segundo = 59 then
					segundo <=0;
					segundos <='1';
				else
					segundo <=segundo+1;
					segundos <='0';
				end if;
			end if;
			
			if enable_m = '1' then
				if minuto = 59 then
					minuto <= 0;
					minutos <='1';
				else
					minuto <= minuto +1;
					minutos <= '0';
				end if;
			end if;
			
			if enable_h='1' then
				if hora = 23 then
					hora <= 0;
				else
					hora <= hora + 1;
				end if;
			end if;
			
		elsif rst='1' then
			segundo<=0;
			segundos<='0';
			minuto<=0;
			minutos<='0';
			hora<=0;
		end if;
		
		if rst = '0' then 
			if enable_min = '1' then
				if minuto_desp=59 then
					minuto_desp <= 0;
				else
					minuto_desp <= minuto_desp + 1;
				end if;
			end if;
			
			if enable_hra = '1' then
				if hora_desp=59 then
					hora_desp<=0;
				else
					hora_desp<=hora_desp+1;
				end if;
			end if;
		else
			hora_desp<=0;
			minuto_desp<=0;
		end if;
		
	end if;
end process;
-----------------------------------------
with mux_camb_min select
enable_m <=	segundos when '0',
				rapido when '1',
				'0' when others;
				
with mux_camb_hra select
enable_h <= minutos when '0',
				rapido when '1',
				'0' when others;

with mux_camb_desp_min select
enable_min <=	'0' when '0',
					rapido when '1',
					'0' when others;
				
with mux_camb_desp_hora select
enable_hra <=	'0' when '0',
					rapido when '1',
					'0' when others;

---------------------------------------------------------------
----- Paso 2: estado_sigiente=f(estado_actual,entradas) -------
process ( rst,conf_min,conf_hora,cmb_hora,cmb_desp,estado_actual )
begin
	case estado_actual is
		
		when reset =>			
			if rst='1' then
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
				estado_siguiente <= inicio;
			end if;
		---------------------------------------------	
			when est_hora =>
				if conf_hora='1' and conf_min='0' and rst='0' and cmb_hora='1' then
					estado_siguiente <= cmb_hra;
				elsif conf_hora='0' and conf_min='1' and rst='0' and cmb_hora='1' then
					estado_siguiente <= cmb_min;
				elsif cmb_hora='0' and rst='0' then
					estado_siguiente <= inicio;
				elsif rst='1' then
					estado_siguiente <= reset;
				else
					estado_siguiente <= est_hora;
				end if;
				---------------------------------------------
				when cmb_hra =>
					if conf_hora <='1' and cmb_hora='1' and rst='0' then
						estado_siguiente <= cmb_hra;
					elsif cmb_hora='0' and rst='0' then
						estado_siguiente <= inicio;
					elsif rst='1' then
						estado_siguiente<=reset;
					else
						estado_siguiente <= est_hora;
					end if;
				
				when cmb_min =>
					if conf_min <='1' and cmb_hora='1' and rst='0' then
						estado_siguiente <= cmb_min;
					elsif cmb_hora='0' and rst='0' then
						estado_siguiente <= inicio;
					elsif rst='1' then
						estado_siguiente<=reset;
					else
						estado_siguiente <= est_hora;
					end if;
				---------------------------------------------
			when est_desp =>
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
-----------------------------------------------------------------------
---------------Paso 3: Las salidas en función del estado---------------
with estado_actual select
mux_camb_hra	<=	'1' when cmb_hra,
						'0' when others;
						
with estado_actual select
mux_camb_min 	<= '1' when cmb_min,
						'0' when others;
						
with estado_actual select
despertador_programado <=	'1' when cmb_desp_hra,
									'1' when cmb_desp_min,
									'0' when reset,
									'X' when others;

with estado_actual select
mux_camb_desp_min	<=	'1' when cmb_desp_min,
							'0' when others;
							
with estado_actual select
mux_camb_desp_hora <=	'1' when cmb_desp_hra,
								'0' when others;
					
with estado_actual select
mux_display	<= '1' when cmb_desp_hra,
					'1' when cmb_desp_min,
					'1' when est_desp,
					'0' when others;
					
with estado_actual select
enable_lento <=	'0' when cmb_min,
						'0' when cmb_hra,
						'0' when est_hora,
						'1' when others;
						
-----------------------------------------------------------------------
-------------------- Paso 4: Cosas del display ------------------------
process(mclk)
	begin
	case mux_display is
		when '0' =>
			case hora is
				when 0 =>
					digitos(0) <= 0;
				when 1 =>			
					digitos(0) <= 0;
				when 2 =>				
					digitos(0) <= 0;
				when 3 =>				
					digitos(0) <= 0;
				when 4 =>				
					digitos(0) <= 0;
				when 5 =>				
					digitos(0) <= 0;
				when 6 =>				
					digitos(0) <= 0;
				when 7 =>				
					digitos(0) <= 0;
				when 8 =>			
					digitos(0) <= 0;
				when 9 =>				
					digitos(0) <= 0;
				when 10 =>				
					digitos(0) <= 1;
				when 11 =>				
					digitos(0) <= 1;
				when 12 =>				
					digitos(0) <= 1;
				when 13 =>			
					digitos(0) <= 1;
				when 14 =>				
					digitos(0) <= 1;
				when 15 =>				
					digitos(0) <= 1;
				when 16 =>				
					digitos(0) <= 1;
				when 17 =>			
					digitos(0) <= 1;
				when 18 =>				
					digitos(0) <= 1;
				when 19 =>				
					digitos(0) <= 1;
				when 20 =>				
					digitos(0) <= 2;
				when 21 =>				
					digitos(0) <= 2;
				when 22 =>				
					digitos(0) <= 2;
				when 23 =>			
					digitos(0) <= 2;
				when others => 
					digitos(0) <= 0;
			end case;
				
			case hora is
				when 0 =>
					digitos(1) <= 0;
				when 1 =>			
					digitos(1) <= 1;
				when 2 =>				
					digitos(1) <= 2;
				when 3 =>				
					digitos(1) <= 3;
				when 4 =>				
					digitos(1) <= 4;
				when 5 =>				
					digitos(1) <= 5;
				when 6 =>				
					digitos(1) <= 6;
				when 7 =>				
					digitos(1) <= 7;
				when 8 =>			
					digitos(1) <= 8;
				when 9 =>				
					digitos(1) <= 9;
				when 10 =>				
					digitos(1) <= 0;
				when 11 =>				
					digitos(1) <= 1;
				when 12 =>				
					digitos(1) <= 2;
				when 13 =>			
					digitos(1) <= 3;
				when 14 =>				
					digitos(1) <= 4;
				when 15 =>				
					digitos(1) <= 5;
				when 16 =>				
					digitos(1) <= 6;
				when 17 =>			
					digitos(1) <= 7;
				when 18 =>				
					digitos(1) <= 8;
				when 19 =>				
					digitos(1) <= 9;
				when 20 =>				
					digitos(1) <= 0;
				when 21 =>				
					digitos(1) <= 1;
				when 22 =>				
					digitos(1) <= 2;
				when 23 =>			
					digitos(1) <= 3;
				when others =>
					digitos(1) <= 0;
			end case;
									
			case minuto is
				when 0 =>
					digitos(2) <= 0;
				when 1 =>			
					digitos(2) <= 0;
				when 2 =>				
					digitos(2) <= 0;
				when 3 =>				
					digitos(2) <= 0;
				when 4 =>				
					digitos(2) <= 0;
				when 5 =>				
					digitos(2) <= 0;
				when 6 =>				
					digitos(2) <= 0;
				when 7 =>				
					digitos(2) <= 0;
				when 8 =>			
					digitos(2) <= 0;
				when 9 =>				
					digitos(2) <= 0;
				when 10 =>				
					digitos(2) <= 1;
				when 11 =>				
					digitos(2) <= 1;
				when 12 =>				
					digitos(2) <= 1;
				when 13 =>			
					digitos(2) <= 1;
				when 14 =>				
					digitos(2) <= 1;
				when 15 =>				
					digitos(2) <= 1;
				when 16 =>				
					digitos(2) <= 1;
				when 17 =>			
					digitos(2) <= 1;
				when 18 =>				
					digitos(2) <= 1;
				when 19 =>				
					digitos(2) <= 1;
				when 20 =>				
					digitos(2) <= 2;
				when 21 =>				
					digitos(2) <= 2;
				when 22 =>				
					digitos(2) <= 2;
				when 23 =>			
					digitos(2) <= 2;
				when 24 =>
					digitos(2) <= 2;
				when 25 =>			
					digitos(2) <= 2;
				when 26=>				
					digitos(2) <= 2;
				when 27 =>				
					digitos(2) <= 2;
				when 28 =>				
					digitos(2) <= 2;
				when 29 =>				
					digitos(2) <= 2;
				when 30 =>				
					digitos(2) <= 3;
				when 31 =>				
					digitos(2) <= 3;
				when 32 =>			
					digitos(2) <= 3;
				when 33 =>				
					digitos(2) <= 3;
				when 34 =>				
					digitos(2) <= 3;
				when 35 =>				
					digitos(2) <= 3;
				when 36 =>				
					digitos(2) <= 3;
				when 37 =>			
					digitos(2) <= 3;
				when 38 =>				
					digitos(2) <= 3;
				when 39 =>				
					digitos(2) <= 3;
				when 40 =>				
					digitos(2) <= 4;
				when 41 =>			
					digitos(2) <= 4;
				when 42 =>				
					digitos(2) <= 4;
				when 43 =>				
					digitos(2) <= 4;
				when 44 =>				
					digitos(2) <= 4;
				when 45 =>				
					digitos(2) <= 4;
				when 46 =>				
					digitos(2) <= 4;
				when 47 =>			
					digitos(2) <= 4;
				when 48 =>				
					digitos(2) <= 4;
				when 49 =>				
					digitos(2) <= 4;
				when 50 =>				
					digitos(2) <= 5;
				when 51 =>			
					digitos(2) <= 5;
				when 52 =>				
					digitos(2) <= 5;
				when 53 =>				
					digitos(2) <= 5;
				when 54 =>				
					digitos(2) <= 5;
				when 55 =>				
					digitos(2) <= 5;
				when 56 =>				
					digitos(2) <= 5;
				when 57 =>			
					digitos(2) <= 5;
				when 58 =>				
					digitos(2) <= 5;
				when 59 =>			
					digitos(2) <= 5;
				when others =>
					digitos(2) <= 0;
			end case;
										
			case minuto is
				when 0 =>
					digitos(3) <= 0;
				when 1 =>			
					digitos(3) <= 1;
				when 2 =>				
					digitos(3) <= 2;
				when 3 =>				
					digitos(3) <= 3;
				when 4 =>				
					digitos(3) <= 4;
				when 5 =>				
					digitos(3) <= 5;
				when 6 =>				
					digitos(3) <= 6;
				when 7 =>				
					digitos(3) <= 7;
				when 8 =>			
					digitos(3) <= 8;
				when 9 =>				
					digitos(3) <= 9;
				when 10 =>				
					digitos(3) <= 0;
				when 11 =>				
					digitos(3) <= 1;
				when 12 =>				
					digitos(3) <= 2;
				when 13 =>			
					digitos(3) <= 3;
				when 14 =>				
					digitos(3) <= 4;
				when 15 =>				
					digitos(3) <= 5;
				when 16 =>				
					digitos(3) <= 6;
				when 17 =>			
					digitos(3) <= 7;
				when 18 =>				
					digitos(3) <= 8;
				when 19 =>				
					digitos(3) <= 9;
				when 20 =>				
					digitos(3) <= 0;
				when 21 =>				
					digitos(3) <= 1;
				when 22 =>				
					digitos(3) <= 2;
				when 23 =>			
					digitos(3) <= 3;
				when 24 =>
					digitos(3) <= 4;
				when 25 =>			
					digitos(3) <= 5;
				when 26 =>				
					digitos(3) <= 6;
				when 27 =>				
					digitos(3) <= 7;
				when 28 =>				
					digitos(3) <= 8;
				when 29 =>				
					digitos(3) <= 9;
				when 30 =>				
					digitos(3) <= 0;
				when 31 =>				
					digitos(3) <= 1;
				when 32 =>			
					digitos(3) <= 2;
				when 33 =>				
					digitos(3) <= 3;
				when 34 =>				
					digitos(3) <= 4;
				when 35 =>				
					digitos(3) <= 5;
				when 36 =>				
					digitos(3) <= 6;
				when 37 =>			
					digitos(3) <= 7;
				when 38 =>				
					digitos(3) <= 8;
				when 39 =>				
					digitos(3) <= 9;
				when 40 =>				
					digitos(3) <= 0;
				when 41 =>			
					digitos(3) <= 1;
				when 42 =>				
					digitos(3) <= 2;
				when 43 =>				
					digitos(3) <= 3;
				when 44 =>				
					digitos(3) <= 4;
				when 45 =>				
					digitos(3) <= 5;
				when 46 =>				
					digitos(3) <= 6;
				when 47 =>			
					digitos(3) <= 7;
				when 48 =>				
					digitos(3) <= 8;
				when 49 =>				
					digitos(3) <= 9;
				when 50 =>				
					digitos(3) <= 0;
				when 51 =>			
					digitos(3) <= 1;
				when 52 =>				
					digitos(3) <= 2;
				when 53 =>				
					digitos(3) <= 3;
				when 54 =>				
					digitos(3) <= 4;
				when 55 =>				
					digitos(3) <= 5;
				when 56 =>				
					digitos(3) <= 6;
				when 57 =>			
					digitos(3) <= 7;
				when 58 =>				
					digitos(3) <= 8;
				when 59 =>			
					digitos(3) <= 9;
				when others =>
					digitos(3) <= 0;
			end case;
			
		when '1' =>
			case hora_desp is
				when 0 =>
					digitos(0) <= 0;
				when 1 =>			
					digitos(0) <= 0;
				when 2 =>				
					digitos(0) <= 0;
				when 3 =>				
					digitos(0) <= 0;
				when 4 =>				
					digitos(0) <= 0;
				when 5 =>				
					digitos(0) <= 0;
				when 6 =>				
					digitos(0) <= 0;
				when 7 =>				
					digitos(0) <= 0;
				when 8 =>			
					digitos(0) <= 0;
				when 9 =>				
					digitos(0) <= 0;
				when 10 =>				
					digitos(0) <= 1;
				when 11 =>				
					digitos(0) <= 1;
				when 12 =>				
					digitos(0) <= 1;
				when 13 =>			
					digitos(0) <= 1;
				when 14 =>				
					digitos(0) <= 1;
				when 15 =>				
					digitos(0) <= 1;
				when 16 =>				
					digitos(0) <= 1;
				when 17 =>			
					digitos(0) <= 1;
				when 18 =>				
					digitos(0) <= 1;
				when 19 =>				
					digitos(0) <= 1;
				when 20 =>				
					digitos(0) <= 2;
				when 21 =>				
					digitos(0) <= 2;
				when 22 =>				
					digitos(0) <= 2;
				when 23 =>			
					digitos(0) <= 2;
				when others =>
					digitos(0) <= 0;
			end case;
			
			case hora_desp is
				when 0 =>
					digitos(1) <= 0;
				when 1 =>			
					digitos(1) <= 1;
				when 2 =>				
					digitos(1) <= 2;
				when 3 =>				
					digitos(1) <= 3;
				when 4 =>				
					digitos(1) <= 4;
				when 5 =>				
					digitos(1) <= 5;
				when 6 =>				
					digitos(1) <= 6;
				when 7 =>				
					digitos(1) <= 7;
				when 8 =>			
					digitos(1) <= 8;
				when 9 =>				
					digitos(1) <= 9;
				when 10 =>				
					digitos(1) <= 0;
				when 11 =>				
					digitos(1) <= 1;
				when 12 =>				
					digitos(1) <= 2;
				when 13 =>			
					digitos(1) <= 3;
				when 14 =>				
					digitos(1) <= 4;
				when 15 =>				
					digitos(1) <= 5;
				when 16 =>				
					digitos(1) <= 6;
				when 17 =>			
					digitos(1) <= 7;
				when 18 =>				
					digitos(1) <= 8;
				when 19 =>				
					digitos(1) <= 9;
				when 20 =>				
					digitos(1) <= 0;
				when 21 =>				
					digitos(1) <= 1;
				when 22 =>				
					digitos(1) <= 2;
				when 23 =>			
					digitos(1) <= 3;
				when others =>
					digitos(1) <= 0;
			end case;
			
			case minuto_desp is
				when 0 =>
					digitos(2) <= 0;
				when 1 =>			
					digitos(2) <= 0;
				when 2 =>				
					digitos(2) <= 0;
				when 3 =>				
					digitos(2) <= 0;
				when 4 =>				
					digitos(2) <= 0;
				when 5 =>				
					digitos(2) <= 0;
				when 6 =>				
					digitos(2) <= 0;
				when 7 =>				
					digitos(2) <= 0;
				when 8 =>			
					digitos(2) <= 0;
				when 9 =>				
					digitos(2) <= 0;
				when 10 =>				
					digitos(2) <= 1;
				when 11 =>				
					digitos(2) <= 1;
				when 12 =>				
					digitos(2) <= 1;
				when 13 =>			
					digitos(2) <= 1;
				when 14 =>				
					digitos(2) <= 1;
				when 15 =>				
					digitos(2) <= 1;
				when 16 =>				
					digitos(2) <= 1;
				when 17 =>			
					digitos(2) <= 1;
				when 18 =>				
					digitos(2) <= 1;
				when 19 =>				
					digitos(2) <= 1;
				when 20 =>				
					digitos(2) <= 2;
				when 21 =>				
					digitos(2) <= 2;
				when 22 =>				
					digitos(2) <= 2;
				when 23 =>			
					digitos(2) <= 2;
				when 24 =>
					digitos(2) <= 2;
				when 25 =>			
					digitos(2) <= 2;
				when 26=>				
					digitos(2) <= 2;
				when 27 =>				
					digitos(2) <= 2;
				when 28 =>				
					digitos(2) <= 2;
				when 29 =>				
					digitos(2) <= 2;
				when 30 =>				
					digitos(2) <= 3;
				when 31 =>				
					digitos(2) <= 3;
				when 32 =>			
					digitos(2) <= 3;
				when 33 =>				
					digitos(2) <= 3;
				when 34 =>				
					digitos(2) <= 3;
				when 35 =>				
					digitos(2) <= 3;
				when 36 =>				
					digitos(2) <= 3;
				when 37 =>			
					digitos(2) <= 3;
				when 38 =>				
					digitos(2) <= 3;
				when 39 =>				
					digitos(2) <= 3;
				when 40 =>				
					digitos(2) <= 4;
				when 41 =>			
					digitos(2) <= 4;
				when 42 =>				
					digitos(2) <= 4;
				when 43 =>				
					digitos(2) <= 4;
				when 44 =>				
					digitos(2) <= 4;
				when 45 =>				
					digitos(2) <= 4;
				when 46 =>				
					digitos(2) <= 4;
				when 47 =>			
					digitos(2) <= 4;
				when 48 =>				
					digitos(2) <= 4;
				when 49 =>				
					digitos(2) <= 4;
				when 50 =>				
					digitos(2) <= 5;
				when 51 =>			
					digitos(2) <= 5;
				when 52 =>				
					digitos(2) <= 5;
				when 53 =>				
					digitos(2) <= 5;
				when 54 =>				
					digitos(2) <= 5;
				when 55 =>				
					digitos(2) <= 5;
				when 56 =>				
					digitos(2) <= 5;
				when 57 =>			
					digitos(2) <= 5;
				when 58 =>				
					digitos(2) <= 5;
				when 59 =>			
					digitos(2) <= 5;
				when others =>
					digitos(2) <= 0;
			end case;
									
			case minuto_desp is
				when 0 =>
					digitos(3) <= 0;
				when 1 =>			
					digitos(3) <= 1;
				when 2 =>				
					digitos(3) <= 2;
				when 3 =>				
					digitos(3) <= 3;
				when 4 =>				
					digitos(3) <= 4;
				when 5 =>				
					digitos(3) <= 5;
				when 6 =>				
					digitos(3) <= 6;
				when 7 =>				
					digitos(3) <= 7;
				when 8 =>			
					digitos(3) <= 8;
				when 9 =>				
					digitos(3) <= 9;
				when 10 =>				
					digitos(3) <= 0;
				when 11 =>				
					digitos(3) <= 1;
				when 12 =>				
					digitos(3) <= 2;
				when 13 =>			
					digitos(3) <= 3;
				when 14 =>				
					digitos(3) <= 4;
				when 15 =>				
					digitos(3) <= 5;
				when 16 =>				
					digitos(3) <= 6;
				when 17 =>			
					digitos(3) <= 7;
				when 18 =>				
					digitos(3) <= 8;
				when 19 =>				
					digitos(3) <= 9;
				when 20 =>				
					digitos(3) <= 0;
				when 21 =>				
					digitos(3) <= 1;
				when 22 =>				
					digitos(3) <= 2;
				when 23 =>			
					digitos(3) <= 3;
				when 24 =>
					digitos(3) <= 4;
				when 25 =>			
					digitos(3) <= 5;
				when 26 =>				
					digitos(3) <= 6;
				when 27 =>				
					digitos(3) <= 7;
				when 28 =>				
					digitos(3) <= 8;
				when 29 =>				
					digitos(3) <= 9;
				when 30 =>				
					digitos(3) <= 0;
				when 31 =>				
					digitos(3) <= 1;
				when 32 =>			
					digitos(3) <= 2;
				when 33 =>				
					digitos(3) <= 3;
				when 34 =>				
					digitos(3) <= 4;
				when 35 =>				
					digitos(3) <= 5;
				when 36 =>				
					digitos(3) <= 6;
				when 37 =>			
					digitos(3) <= 7;
				when 38 =>				
					digitos(3) <= 8;
				when 39 =>				
					digitos(3) <= 9;
				when 40 =>				
					digitos(3) <= 0;
				when 41 =>			
					digitos(3) <= 1;
				when 42 =>				
					digitos(3) <= 2;
				when 43 =>				
					digitos(3) <= 3;
				when 44 =>				
					digitos(3) <= 4;
				when 45 =>				
					digitos(3) <= 5;
				when 46 =>				
					digitos(3) <= 6;
				when 47 =>			
					digitos(3) <= 7;
				when 48 =>				
					digitos(3) <= 8;
				when 49 =>				
					digitos(3) <= 9;
				when 50 =>				
					digitos(3) <= 0;
				when 51 =>			
					digitos(3) <= 1;
				when 52 =>				
					digitos(3) <= 2;
				when 53 =>				
					digitos(3) <= 3;
				when 54 =>				
					digitos(3) <= 4;
				when 55 =>				
					digitos(3) <= 5;
				when 56 =>				
					digitos(3) <= 6;
				when 57 =>			
					digitos(3) <= 7;
				when 58 =>				
					digitos(3) <= 8;
				when 59 =>			
					digitos(3) <= 9;
				when others =>
					digitos(3) <= 0;
			end case;
		when others =>
			digitos(0) <= 0;
			digitos(1) <= 0;
			digitos(2) <= 0;
			digitos(3) <= 0;
	end case;
end process;


with digito_ssg select
ssg  <=		 "11000000" when 0,   --0
				 "01111001" when 1,   --1
				 "00100100" when 2,   --2
				 "00110000" when 3,   --3
				 "00011001" when 4,   --4
				 "00010010" when 5,   --5
				 "00000010" when 6,   --6
				 "01111000" when 7,   --7
				 "00000000" when 8,   --8
				 "00010000" when 9,   --9
				 "00000000" when others;



-----------------------------------------------------------------------
-------------------- Paso 4: Cosas de la alarma -----------------------

alarma <= (despertador_programado and alarmita);

process (rapido)
begin
		if alarma = '1' then
			if rapido='1' then
				led<="00000000";
			else
				led<="11111111";
			end if;
		else 
			led<="11111111";
		end if;

end process;


end Behavioral;