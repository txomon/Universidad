
-- VHDL Instantiation Created from source file bcdssg.vhd -- 13:59:57 10/28/2010
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT bcdssg
	PORT(
		clk : IN std_logic;
		bcd : IN std_logic_vector(3 downto 0);          
		ssg : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;

	Inst_bcdssg: bcdssg PORT MAP(
		clk => ,
		bcd => ,
		ssg => 
	);


