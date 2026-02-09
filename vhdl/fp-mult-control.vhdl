library ieee;
use ieee.std_logic_1164.all;

entity fpmult_control is
  port(
    GClock, GReset : in std_logic;
    i_cOutMantissaSum, i_isSameSign: in std_logic;

    loadMA,
    loadMB, 
    loadExpA,
    loadExpB,
    loadExpSum,
    loadSign,
    selAluResult,
    selBias, 
    countUpExpSum,
    sumMantissaShiftR : out std_logic
);
end fpmult_control;

architecture strucutral of fpmult_control is

signal int_state_in, int_state_out: std_logic_vector(4 downto 0);

alias s0 : std_logic is int_state_out(0);
alias s1 : std_logic is int_state_out(1);
alias s2 : std_logic is int_state_out(2);
alias s3 : std_logic is int_state_out(3);
alias s4 : std_logic is int_state_out(4);
alias s5 : std_logic is int_state_out(5);

alias s0_in : std_logic is int_state_in(0);
alias s1_in : std_logic is int_state_in(1);
alias s2_in : std_logic is int_state_in(2);
alias s3_in : std_logic is int_state_in(3);
alias s4_in : std_logic is int_state_in(4);
alias s5_in : std_logic is int_state_in(5);

component dFF_2 is 
  port (
		i_d	: in std_logic;
		i_clock	: in std_logic;
		o_q, o_qbar	: out	std_logic
  );
end component;
begin

state_bits: for i in 5 downto 0 generate 
  s_i: dFF_2 port map (
    i_clock => GClock,
    i_d => int_state_in(i),
    o_q => int_state_out(i)
  ); 
end generate;

s0_in <= GReset;
s1_in <= s0;
s2_in <= s1;
s3_in <= s2 and i_cOutMantissaSum;
s4_in <= s3;
s5_in <= s4;

loadMA <= s0;
loadMB <= s0;
loadExpA <= s0;
loadExpB <= s0;
loadExpSum <= s1;
selAluResult <= s1;
selBias <= s1;
loadSign <= s4;
countUpExpSum <= s3;
sumMantissaShiftR <= s3;

end architecture;
