
-- VHDL Instantiation Created from source file estado_siguiente.vhd -- 13:30:53 11/18/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT estado_siguiente
	PORT(
		s1 : IN std_logic;
		s2 : IN std_logic;
		reset : IN std_logic;
		actual : IN std_logic_vector(3 downto 0);
		num_actual : IN std_logic_vector(3 downto 0);          
		siguiente : OUT std_logic_vector(3 downto 0);
		num_siguiente : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_estado_siguiente: estado_siguiente PORT MAP(
		s1 => ,
		s2 => ,
		reset => ,
		actual => ,
		siguiente => ,
		num_actual => ,
		num_siguiente => 
	);


