library ieee;
use ieee.std_logic_1164.all;


entity Multiplier4bit is
	port(
		A : in std_logic_vector(3 downto 0);
		B : in std_logic_vector(3 downto 0);
		Y : out std_logic_vector(7 downto 0)
	);
end Multiplier4bit;

architecture rtl of Multiplier4bit is
	signal pp00, pp01, pp02, pp03, pp04 : std_logic;
	signal pp10, pp11, pp12, pp13, pp14 : std_logic;
	signal pp20, pp21, pp22, pp23, pp24 : std_logic;
	signal pp30, pp31, pp32, pp33, pp34 : std_logic;
	
	signal c_o0, c_o1,c_o2,c_o3,c_o4,c_o5,c_o6,c_o7,c_o8,c_o9 : std_logic;
	signal c_o23, c_o45, c_o56, c_o67, c_o78: std_logic;
	--c_o 
	
	component fullAdder is 
		port(
			A: in std_logic;
			B: in std_logic;
			c_i: in std_logic;
			c_o: out std_logic;
			S: out std_logic
		);
	end component;
begin
	--------------------- Y(0)
	y_0 : fullAdder
		port map(
			A => A(0) and B(0),
			B => '0',
			c_i => '0',
			c_o => c_o0,
			S => pp00 
		);
	--------------------- Y(1)
	y_1 : fullAdder
		port map(
			A => A(1) and B(0),
			B => A(0) and B(1),
			c_i => c_o0,
			c_o => c_o1,
			S => pp10
		);
	
	--------------------- Y(2)
	p1_1 : fullAdder
		port map(
			A => A(2) and B(0),
			B => A(1) and B(1),
			c_i => c_o1,
			c_o => c_o2,
			S => pp11
		);
		
	y_2 : fullAdder
		port map(
			A => pp11,
			B => A(0) and B(2),
			c_i => '0',
			c_o => c_o3,
			S => pp20
		);
	
	--------------------- Y(3)
	
	c_2 : fullAdder
		port map(
			A => c_o3,
			B =>  c_o2,
			c_i => '0',
			c_o => open,
			S => c_o23
		);
	
	p1_2 : fullAdder
		port map(
			A => A(3) and B(0),
			B => A(2) and B(1),
			c_i => c_o23,
			c_o => c_o4,
			S => pp12
		);
		
	p2_1 : fullAdder
		port map(
			A => pp12,
			B => A(1) and B(2),
			c_i => '0',
			c_o => c_o5,
			S => pp21
		);
		
	y_3 : fullAdder
		port map(
			A => pp21,
			B => A(0) and B(3),
			c_i => '0',
			c_o => c_o6,
			S => pp30
		);
		
	--------------------- Y(4)
	
	c_3 : fullAdder
		port map(
			A => c_o4,
			B =>  c_o5,
			c_i => c_o6,
			c_o => c_o56,
			S => c_o45
		);
	
	p2_2 : fullAdder
		port map(
			A => A(3) and B(1),
			B => A(2) and B(2),
			c_i => c_o45,
			c_o => c_o7,
			S => pp22
		);
	
	y_4 : fullAdder
		port map(
			A => pp22,
			B => A(1) and B(3),
			c_i => '0',
			c_o => c_o8,
			S => pp31
		);
	
	--------------------- Y(5)
	
	c_4 : fullAdder
		port map(
			A => c_o56,
			B =>  c_o7,
			c_i => c_o8,
			c_o => c_o78,
			S => c_o67
		);
	
	y_5 : fullAdder
		port map(
			A => A(3) and B(2),
			B => A(2) and B(3),
			c_i => c_o67,
			c_o => c_o9,
			S => pp32
		);
		
	--------------------- Y(6)
	
	
	
	p3_3 : fullAdder
		port map(
			A => A(3) and B(3),
			B => c_o78,
			c_i => c_o9,
			c_o => pp34,
			S => pp33
		);
		
	Y(0) <= pp00;
	Y(1) <= pp10;
	Y(2) <= pp20;
	Y(3) <= pp30;
	Y(4) <= pp31;
	Y(5) <= pp32;
	Y(6) <= pp33;
	Y(7) <= pp34;

end rtl;