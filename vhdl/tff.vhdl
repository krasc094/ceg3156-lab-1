library ieee;
use ieee.std_logic_1164.all;
entity tFlip is
  port (
    i_toggle, i_clk : in std_logic;
    i_reset_bar : in std_logic;
    o_q, o_qBar : out std_logic
  );
end tFlip;

architecture structural of tFlip is
  signal int_d : std_logic := '0';
  signal int_q : std_logic := '0';
  signal int_qBar: std_logic := '1';

component dFlip is
	  port (
		 i_d : in std_logic;
		 i_clk : in	std_logic;
		 i_reset_bar : in std_logic;
		 o_q, o_qBar : out std_logic
	  );
  end component;
begin

  d : dFlip
  port map (
    i_d => int_d,
    i_clk => i_clk,
    i_reset_bar => i_reset_bar,
    o_q => int_q,
    o_qBar => int_qBar
  );

  int_d <=
  -- int_q when i_toggle = '0' else int_qBar;
  (not i_toggle and int_q) or (i_toggle and int_qBar);

  o_q <= int_q;
  o_qBar <= int_qBar;

end architecture;

-- ==== TESTBENCH ====
library ieee;
use ieee.std_logic_1164.all;
entity tff_TB is end tff_TB;
architecture testbench of tff_TB is
  component tFlip is
  port (
    i_toggle, i_clk : in std_logic;
	 i_reset_bar : in std_logic;
    o_q, o_qBar : out std_logic
  );
  end component;

  signal clk_tb : std_logic;
  signal toggle_tb : std_logic;
  signal reset_bar_tb : std_logic;
  signal q_tb : std_logic;
  signal qBar_tb : std_logic;

  signal sim_end : boolean := false;
  constant CLOCK_PERIOD : time := 20 ns;
begin

  dut: tFlip
  port map (
    i_clk => clk_tb,
    i_toggle => toggle_tb,
    i_reset_bar => reset_bar_tb,
    o_q => q_tb,
    o_qBar => qBar_tb
  );

  clock_process:
  process begin
    while (not sim_end) loop
      clk_tb <= '1';
      wait for clock_period / 2;
      clk_tb <= '0';
      wait for clock_period / 2;
    end loop;
    wait;
  end process clock_process;

  stimulus: 
  process begin 
    toggle_tb <= '0';
    wait for clock_period; -- falling edge  
    reset_bar_tb <= '1'; 
    assert q_TB = '0' report "fail: tff doesn't start in 0 state";

    wait for clock_period / 2; -- rising
    toggle_tb <= '1';
    
    wait for clock_period; -- rising
    assert q_TB = '1' report "fail: tff toggle failed";
    sim_end <= true;
    wait;
  end process stimulus;
  end architecture;

