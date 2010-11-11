
-- VHDL Instantiation Created from source file cambio_estado.vhd -- 14:04:09 11/11/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT cambio_estado
	PORT(
		clk : IN std_logic;
		actual : IN std_logic_vector(3 downto 0);          
		siguiente : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_cambio_estado: cambio_estado PORT MAP(
		clk => ,
		actual => ,
		siguiente => 
	);


