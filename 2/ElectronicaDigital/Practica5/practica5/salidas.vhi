
-- VHDL Instantiation Created from source file salidas.vhd -- 14:05:43 11/11/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT salidas
	PORT(
		actual : IN std_logic_vector(3 downto 0);          
		led : OUT std_logic_vector(7 downto 0);
		ssg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_salidas: salidas PORT MAP(
		led => ,
		ssg => ,
		actual => 
	);


