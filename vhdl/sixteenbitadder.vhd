
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sixteenbitadder IS
	PORT(
		i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(15 downto 0);
		i_CarryIn		: IN	STD_LOGIC;
		o_CarryOut		: OUT	STD_LOGIC;
		o_Sum			: OUT	STD_LOGIC_VECTOR(15 downto 0));
END sixteenbitadder;

ARCHITECTURE rtl OF sixteenbitadder IS
	SIGNAL int_Sum, int_CarryOut : STD_LOGIC_VECTOR(15 downto 0);

	component fullAdder is 
		port(
			A: in std_logic;
			B: in std_logic;
			c_i: in std_logic;
			c_o: out std_logic;
			S: out std_logic
		);
	end component;

BEGIN

add0: fullAdder
	PORT MAP ( 
			  A => i_Ai(0),
			  B => i_Bi(0),
			  c_i => i_CarryIn,
			  c_o => int_CarryOut(0),
			  S => int_Sum(0));

add1: fullAdder
	PORT MAP ( 
			  A => i_Ai(1),
			  B => i_Bi(1),
			  c_i => int_CarryOut(0),
			  c_o => int_CarryOut(1),
			  S => int_Sum(1));


add2: fullAdder
	PORT MAP (
			  A => i_Ai(2),
			  B => i_Bi(2),
			  c_i => int_CarryOut(1),
			  c_o => int_CarryOut(2),
			  S => int_Sum(2));

add3: fullAdder
	PORT MAP ( 
			  A => i_Ai(3),
			  B => i_Bi(3),
			  c_i => int_CarryOut(2),
			  c_o => int_CarryOut(3),
			  S => int_Sum(3));

add4: fullAdder
	PORT MAP (
			  A => i_Ai(4),
			  B => i_Bi(4),
			  c_i => int_CarryOut(3), 
			  c_o => int_CarryOut(4),
			  S => int_Sum(4));

add5: fullAdder
	PORT MAP ( 
			  A => i_Ai(5),
			  B => i_Bi(5),
			  c_i => int_CarryOut(4),
			  c_o => int_CarryOut(5),
			  S => int_Sum(5));

add6: fullAdder
	PORT MAP (
			  A => i_Ai(6),
			  B => i_Bi(6),
			  c_i => int_CarryOut(5), 
			  c_o => int_CarryOut(6),
			  S => int_Sum(6));

add7: fullAdder
	PORT MAP ( 
			  A => i_Ai(7),
			  B => i_Bi(7),
			  c_i => int_CarryOut(6),
			  c_o => int_CarryOut(7),
			  S => int_Sum(7));
			  
add8: fullAdder
	PORT MAP ( 
			  A => i_Ai(8),
			  B => i_Bi(8),
			  c_i => int_CarryOut(7),
			  c_o => int_CarryOut(8),
			  S => int_Sum(8));
			  
add9: fullAdder
	PORT MAP ( 
			  A => i_Ai(9),
			  B => i_Bi(9),
			  c_i => int_CarryOut(8),
			  c_o => int_CarryOut(9),
			  S => int_Sum(9));			  
add10: fullAdder
	PORT MAP (
			  A => i_Ai(10),
			  B => i_Bi(10),
			  c_i => int_CarryOut(9),
			  c_o => int_CarryOut(10),
			  S => int_Sum(10));

add11: fullAdder
	PORT MAP ( 
			  A => i_Ai(11),
			  B => i_Bi(11),
			  c_i => int_CarryOut(10),
			  c_o => int_CarryOut(11),
			  S => int_Sum(11));

add12: fullAdder
	PORT MAP (
			  A => i_Ai(12),
			  B => i_Bi(12),
			  c_i => int_CarryOut(11), 
			  c_o => int_CarryOut(12),
			  S => int_Sum(12));

add13: fullAdder
	PORT MAP ( 
			  A => i_Ai(13),
			  B => i_Bi(13),
			  c_i => int_CarryOut(12),
			  c_o => int_CarryOut(13),
			  S => int_Sum(13));

add14: fullAdder
	PORT MAP (
			  A => i_Ai(14),
			  B => i_Bi(14),
			  c_i => int_CarryOut(13), 
			  c_o => int_CarryOut(14),
			  S => int_Sum(14));

add15: fullAdder
	PORT MAP ( 
			  A => i_Ai(15),
			  B => i_Bi(15),
			  c_i => int_CarryOut(14),
			  c_o => int_CarryOut(15),
			  S => int_Sum(15));
			  
			  
	-- Output Driver
	o_Sum <= int_Sum;
	o_CarryOut <= int_CarryOut(15);

END rtl;
