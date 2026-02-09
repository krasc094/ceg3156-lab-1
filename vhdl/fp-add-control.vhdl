library ieee;
use ieee.std_logic_1164.all;

entity fpadd_control is
  port(
    GClock, GReset : in std_logic;
    i_expDiffZero, i_expDiffMore8, i_sumCout: in std_logic;
    aHigher: in std_logic;

    loadMA, loadMB, 
    loadExpA, loadExpB, 
    loadExpDiff,
    loadMantissaSum, loadExpSum : out std_logic;
    clearHigherMantissa: out std_logic;
    countDownED, countUpES, sumShiftR: out std_logic

);
end fpadd_control;

architecture strucutral of fpadd_control is

signal int_state_in, int_state_out: std_logic_vector(4 downto 0);

alias s0 : std_logic is int_state_out(0);
alias s1 : std_logic is int_state_out(1);
alias s2 : std_logic is int_state_out(2);
alias s3 : std_logic is int_state_out(3);
alias s4 : std_logic is int_state_out(4);
alias s5 : std_logic is int_state_out(5);
alias s6 : std_logic is int_state_out(6);

alias s0_in : std_logic is int_state_in(0);
alias s1_in : std_logic is int_state_in(1);
alias s2_in : std_logic is int_state_in(2);
alias s3_in : std_logic is int_state_in(3);
alias s4_in : std_logic is int_state_in(4);
alias s5_in : std_logic is int_state_in(5);
alias s6_in : std_logic is int_state_in(6);

component dFF_2 is 
  port (
		i_d	: in std_logic;
		i_clock	: in std_logic;
		o_q, o_qbar	: out	std_logic
  );
end component;
begin

state_bits: for i in 6 downto 0 generate 
  s_i: dFF_2 port map (
  i_clock => GClock,
  i_d => int_state_in(i),
  o_q => int_state_out(i)
); 
end generate;

s0_in <= GReset;
s1_in <= s0;
s2_in <= i_expDiffMore8 and s1;
s3_in <= (s1 and 
          not i_expDiffZero and 
          not i_expDiffMore8) 
        or (s3 and not i_expDiffZero);
s4_in <= s2 or 
        (s1 and not i_expDiffMore8 and i_expDiffZero) or 
        (s3 and i_expDiffZero);
s5_in <= s4 and not i_sumCout;
s6_in <= (s4 and not i_sumCout) or (s5);

loadMA <= s0;
loadMB <= s0;
loadExpA <= s0;
loadExpB <= s0;
loadExpDiff <= s1;
clearHigherMantissa <= s2;
countDownED <= s3;
loadMantissaSum <= s4 or s6;
loadExpSum <= s4;
countUpES <= s5;
sumShiftR <= s5;

end architecture;
