library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multiplier8bit is
	port(
		A: in std_logic_vector(7 downto 0);
		B: in std_logic_vector(7 downto 0);
		c_in: std_logic;
		Y: out std_logic_vector(15 downto 0)
	);
end Multiplier8bit;

architecture rtl of Multiplier8bit is
	signal f1, f2, s1, s2 : std_logic_vector(7 downto 0);
	signal f1_ext, f2_ext, s1_ext, s2_ext, sum1, sum1_shift, sum2, finalProd : std_logic_vector(15 downto 0);
	signal c_out : std_logic;
	
	component Multiplier4bit is
		port(
		A : in std_logic_vector(3 downto 0);
		B : in std_logic_vector(3 downto 0);
		Y : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component sixteenbitadder IS
		PORT(
			i_Ai, i_Bi		: IN	STD_LOGIC_VECTOR(15 downto 0);
			i_CarryIn		: IN	STD_LOGIC;
			o_CarryOut		: OUT	STD_LOGIC;
			o_Sum			: OUT	STD_LOGIC_VECTOR(15 downto 0));
	end component;
	
begin 
	f_1 : Multiplier4bit 
		port map(
			A => A(3 downto 0),
			B => B(3 downto 0),
			Y => f1
		);
		
	f_2 : Multiplier4bit 
		port map(
			A => A(3 downto 0),
			B => B(7 downto 4),
			Y => f2
		);
	
	s_1 : Multiplier4bit 
		port map(
			A => A(7 downto 4),
			B => B(3 downto 0),
			Y => s1
		);
	
	s_2 : Multiplier4bit 
		port map(
			A => A(7 downto 4),
			B => B(7 downto 4),
			Y => s2
		);

	
	f1_ext <= "00000000" & f1;
	f2_ext <= "00000000" & f2;
	s1_ext <= "00000000" & s1;
	s2_ext <= s2 & "00000000";
	
	
	sum_1 : sixteenbitadder 
		port map(
			i_Ai => f2_ext, 
			i_Bi => s1_ext,
			i_CarryIn => '0',
			o_CarryOut => open, -- no need here
			o_Sum	=> sum1);
	
	
	sum1_shift <=  sum1(11 downto 0) & "0000";
	
	sum_2 : sixteenbitadder 
		port map(
			i_Ai => sum1_shift, 
			i_Bi => f1_ext,
			i_CarryIn => '0',
			o_CarryOut =>  open, -- no need here
			o_Sum	=> sum2);
	
	
	final_Prod : sixteenbitadder 
		port map(
			i_Ai => sum2, 
			i_Bi => s2_ext,
			i_CarryIn => '0',
			o_CarryOut => c_out, -- no need here
			o_Sum	=> finalProd);
	
		Y <= finalProd;
		
end rtl;
