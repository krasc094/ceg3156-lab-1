LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nBitComparator IS
  generic ( n : integer := 7 );
	PORT(
		i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(n-1 downto 0);
		o_GT, o_LT, o_EQ		: OUT	STD_LOGIC);
END nBitComparator;

ARCHITECTURE rtl OF nBitComparator IS
	SIGNAL int_GT, int_LT : STD_LOGIC_VECTOR(n-1 downto 0);
	SIGNAL gnd : STD_LOGIC;

	COMPONENT oneBitComparator
	PORT(
		i_GTPrevious, i_LTPrevious	: IN	STD_LOGIC;
		i_Ai, i_Bi			: IN	STD_LOGIC;
		o_GT, o_LT			: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN
	-- Concurrent Signal Assignment
	gnd <= '0';

comp_msb: oneBitComparator
	PORT MAP (
    i_GTPrevious => gnd, 
    i_LTPrevious => gnd,
    i_Ai => i_Ai(n-1),
    i_Bi => i_Bi(n-1),
    o_GT => int_GT(n-1),
    o_LT => int_LT(n-1)
  );

comps: for i in n-2 downto 0 generate
  comp: oneBitComparator
  port map (
    i_GTPrevious => int_GT(i+1), 
    i_LTPrevious => int_LT(i+1),
    i_Ai => i_Ai(i),
    i_Bi => i_Bi(i),
    o_GT => int_GT(i),
    o_LT => int_LT(i)
  );
end generate comps;

	-- Output Driver
	o_GT <= int_GT(0);
	o_LT <= int_LT(0);
	o_EQ <= int_GT(0) nor int_LT(0);

END rtl;
