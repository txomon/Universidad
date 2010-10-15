
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   15:03:14 10/14/2010
-- Design Name:   entidad
-- Module Name:   C:/MIJ/2/Electronica Digital/practica3/practica3/testpractica3.vhd
-- Project Name:  practica3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: entidad
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY testpractica3_vhd IS
END testpractica3_vhd;

ARCHITECTURE behavior OF testpractica3_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT entidad
	PORT(
		mclk : IN std_logic;
		btn : IN std_logic_vector(3 downto 0);
		swt : IN std_logic_vector(7 downto 0);          
		led : OUT std_logic_vector(7 downto 0);
		an : OUT std_logic_vector(3 downto 0);
		ssg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	--Inputs
	SIGNAL mclk :  std_logic := '0';
	SIGNAL btn :  std_logic_vector(3 downto 0) := (others=>'0');
	SIGNAL swt :  std_logic_vector(7 downto 0) := (others=>'0');

	--Outputs
	SIGNAL led :  std_logic_vector(7 downto 0);
	SIGNAL an :  std_logic_vector(3 downto 0);
	SIGNAL ssg :  std_logic_vector(7 downto 0);

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut: entidad PORT MAP(
		mclk => mclk,
		btn => btn,
		swt => swt,
		led => led,
		an => an,
		ssg => ssg
	);

	tb : PROCESS
	BEGIN

		-- Wait 100 ns for global reset to finish
		wait for 100 ns;

		-- Place stimulus here

		wait; -- will wait forever
	END PROCESS;

END;
