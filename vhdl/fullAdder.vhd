--full adder

library ieee;
use ieee.std_logic_1164.all;


entity fullAdder is
	port(
		A: in std_logic;
		B: in std_logic;
		c_i: in std_logic;
		c_o: out std_logic;
		S: out std_logic
	);
end fullAdder;

architecture rtl of fullAdder is
begin 
	S <=(c_i and (not(A) and not(B))) or
		(not(c_i) and (not(A) and B)) or
		(c_i and (A and B)) or
		(not(c_i) and (A and not(B)));
	c_o <= (c_i and B) or (A and B) or (c_i and A);
		
end rtl;
