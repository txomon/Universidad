
-- VHDL Instantiation Created from source file principal.vhd -- 14:05:31 11/11/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT principal
	PORT(
		mclk : IN std_logic;
		btn : IN std_logic_vector(3 downto 0);
		swt : IN std_logic_vector(7 downto 0);          
		led : OUT std_logic_vector(7 downto 0);
		an : OUT std_logic_vector(3 downto 0);
		ssg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_principal: principal PORT MAP(
		mclk => ,
		btn => ,
		swt => ,
		led => ,
		an => ,
		ssg => 
	);


