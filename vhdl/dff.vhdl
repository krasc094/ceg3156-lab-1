library ieee;
use ieee.std_logic_1164.all;
entity dFlipFlop is
  port (
    i_d			: in	std_logic;
    i_clk			: in	std_logic;
    i_reset_bar : in std_logic;
    o_q, o_qBar		: out	std_logic
  );
end dFlipFlop;

architecture structural of dFlipFlop is
  signal a : std_logic := '0';
  signal b, c : std_logic := '1';
  signal d : std_logic := '1';
  signal int_q : std_logic := '0';
  signal int_qBar : std_logic := '1';
begin
  a <= d nand b;
  b <= not (a and i_clk and i_reset_bar);
  c <= not (b and d and i_clk);
  d <= not (c and i_d and i_reset_bar) after 0.5 ns;
  
  int_q <= b nand int_qBar;
  int_qBar <= not (int_q and c and i_reset_bar);

  o_q <= int_q;
  o_qBar <= int_qBar;
end architecture;
