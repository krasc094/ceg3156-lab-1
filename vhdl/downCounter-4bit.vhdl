--- made by Kai Rasco #300304789
--- for ceg3155

library ieee;
use ieee.std_logic_1164.all;
entity counterController is 
  port (
    i_current : in std_logic_vector(3 downto 0);
    o_toggle : out std_logic_vector(3 downto 0)
  );
end counterController;

architecture structural of counterController is 
  alias b3 : std_logic is i_current(3);
  alias b2 : std_logic is i_current(2);
  alias b1 : std_logic is i_current(1);
  alias b0 : std_logic is i_current(0);
begin
  o_toggle(3) <= b3 and not b2 and not b1 and not b0 ;

  o_toggle(2) <= (b3 and not b1 and not b0) or 
              (b2 and not b1 and not b0);

  o_toggle(1) <= (b3 and not b1 and not b0) or
                 (b2 and not b1 and not b0) or
                 (b1 and not b0);
              

  o_toggle(0) <= b3 or b2 or b1 or b0;
  end architecture;

-- ==== DOWN COUNTER WITH LOAD IN
library ieee;
use ieee.std_logic_1164.all;
entity downCounter is 
  port (
    i_data : in std_logic_vector(3 downto 0);
    i_clk, i_load : in std_logic;  
    i_reset_bar : in std_logic;
    o_isZero : out std_logic;
    o_count : out std_logic_vector(3 downto 0)
  );
end downCounter;

architecture structural of downCounter is
  signal int_t, int_q: std_logic_vector(3 downto 0) := "0000"; 
  signal int_a, int_data : std_logic_vector(3 downto 0) := "0000";

  alias q3 : std_logic is int_q(3);
  alias q2 : std_logic is int_q(2);
  alias q1 : std_logic is int_q(1);
  alias q0 : std_logic is int_q(0);
  
  component counterController is
    port (
      i_current : in std_logic_vector(3 downto 0);
      o_toggle : out std_logic_vector(3 downto 0)
    );
  end component;

  component tFlip is
    port (
      i_toggle, i_clk : in std_logic;
      i_reset_bar : in std_logic;
      o_q, o_qBar : out std_logic
    );
  end component;

  component mux2x1_4bit is
    port (
      a, b: in std_logic_vector(3 downto 0);
      sel : in std_logic;
      o : out std_logic_vector(3 downto 0)
    );
  end component;
begin
  -- int_t is the input of the flipflops
  -- int_q is the output of the flipflops
  -- int_a controls toggle for the counting mode 
  -- int_data controls toggle for loading mode 
  
  controller : counterController
  port map (
    i_current => int_q,
    o_toggle => int_a
  );
  
  xors: for i in 3 downto 0 generate
    int_data(i) <= i_data(i) xor int_q(i);
  end generate xors;
  
  o_isZero <= not ( q3 or q2 or q1 or q0 ); 
  o_count <= int_q;

  mux : mux2x1_4bit 
  port map (
    sel => i_load, 
    a => int_a,
    b => int_data,
    o => int_t
  );

  msb_b3 : tFlip
  port map (
     i_clk => i_clk,
     i_reset_bar => i_reset_bar,
     i_toggle => int_t(3),
     o_q => q3
  );
  b2 : tFlip
  port map (
     i_clk => i_clk,
     i_reset_bar => i_reset_bar,
     i_toggle => int_t(2),
     o_q => q2
  );
  b1 : tFlip
  port map ( 
     i_clk => i_clk,
     i_reset_bar => i_reset_bar,
     i_toggle => int_t(1),
     o_q => q1
  );
  lsb_b0 : tFlip
  port map (
     i_clk => i_clk,
     i_reset_bar => i_reset_bar,
     i_toggle => int_t(0),
     o_q => q0
  );
end architecture;

-- ==== DOWNCOUNTER TESTBENCH 
library ieee;
use ieee.std_logic_1164.all;
entity downCounter_tb is end;
architecture testbench of downCounter_tb is
  signal data_tb : std_logic_vector(3 downto 0);
  signal count_tb : std_logic_vector(3 downto 0);
  signal clk_tb, load_tb : std_logic;  
  signal reset_bar_tb : std_logic;
  signal isZero_tb : std_logic;
  signal sim_end : boolean := false;

  constant CLOCK_PERIOD : time := 20 ns;

begin 
  dut: entity work.downCounter
  port map (
    i_clk => clk_tb,
    i_data => data_tb,
    i_load => load_tb,
    i_reset_bar => reset_bar_tb,
    o_isZero => isZero_tb,
    o_count => count_tb
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
    load_tb <= '1'; reset_bar_tb <= '1';
    wait for clock_period / 2; -- rising edge 
    data_tb <= "1111"; load_tb <= '1';
    wait for clock_period;
    assert count_tb = "1111";
    load_tb <= '0';

    wait for clock_period * 18;
    sim_end <= true;
    wait;
  end process stimulus;
end architecture;
