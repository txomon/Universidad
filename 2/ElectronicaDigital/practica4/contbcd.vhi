
-- VHDL Instantiation Created from source file contbcd.vhd -- 13:58:21 10/28/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT contbcd
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		dir : IN std_logic;
		enable : IN std_logic;          
		bcd : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;

	Inst_contbcd: contbcd PORT MAP(
		clk => ,
		rst => ,
		dir => ,
		enable => ,
		bcd => 
	);


