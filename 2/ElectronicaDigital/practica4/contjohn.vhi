
-- VHDL Instantiation Created from source file contjohn.vhd -- 14:10:36 10/21/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT contjohn
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		dir : IN std_logic;
		enable : IN std_logic;          
		led : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_contjohn: contjohn PORT MAP(
		clk => ,
		rst => ,
		dir => ,
		enable => ,
		led => 
	);


