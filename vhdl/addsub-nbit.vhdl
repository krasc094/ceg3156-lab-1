-- 9bitadder
-- made by Kai Rasco #300304789
-- for ceg3155

-- slightly modifier (factored out inverter)

-- ==== n-bit CARRY RIPPLE ADDER/SUBTRACTOR
library ieee;
use ieee.std_logic_1164.all;
entity addsub is
  generic ( n : integer := 4 );
  port (
    x , y: in std_logic_vector(n-1 downto 0);
    ci: in std_logic;
    s: out std_logic_vector(n-1 downto 0);
    co: out std_logic
 );
 end addsub;

architecture structural of addsub is
  signal i_carry : std_logic_vector(n-1 downto 0);
  signal i_y : std_logic_vector(n-1 downto 0);

  component fulladder_1bit is
    port (
      a, b, ci : in std_logic;
      s, co : out std_logic
    );
  end component;
begin
  invert_y: for i in n-1 downto 0 generate
    noty : entity work.inverter(structural)
    port map (
      y(i), ci, i_y(i)
    );
  end generate invert_y;

  adders: for i in n-2 downto 1 generate
    fulladder: fulladder_1bit
    port map ( 
      a => x(i),
      b => i_y(i),
      ci => i_carry(i-1),
      s => s(i),
      co => i_carry(i)
    );
  end generate adders;

  lsb:fulladder_1bit
  port map (
    a => x(0),
    b => i_y(0),
    ci => ci,
    s => s(0),
    co => i_carry(0)
  );

  msb:fulladder_1bit
  port map (
    a => x(n-1),
    b => i_y(n-1),
    ci => i_carry(n-2),
    s => s(n-1),
    co => co
  );
end structural;

-- ==== n-bit ADDER TESTBENCH
library ieee;
use ieee.std_logic_1164.all;
entity addsub_4bit_TB is
end addsub_4bit_TB;
architecture testbench of addsub_4bit_TB is 
  signal x_tb, y_tb : std_logic_vector(3 downto 0) := "0000";
  signal ci_tb : std_logic;
  signal sum_tb : std_logic_vector(3 downto 0) := "0000";
  signal co_tb : std_logic;

  signal clock_tb : std_logic := '0';
  signal sim_end : BOOLEAN := false;

  constant CLOCK_PERIOD : time := 20 ns;
begin
  dut: entity work.addsub(structural)
  port map (
    x => x_tb,
    y => y_tb, 
    ci => ci_tb,
    s => sum_tb,
    co => co_tb
  );

  clock_process:
  process begin
    while (not sim_end) loop
      clock_tb <= '1';
      wait for clock_period / 2;
      clock_tb <= '0';
      wait for clock_period / 2;
    end loop;
    wait;
  end process clock_process;

  stimulus:
  process begin 
  wait for clock_period;
  -- TODO: ADD TESTS

  ci_tb <= '0';

  x_tb <= "1100"; y_tb <= "0001";
  wait for clock_period;


  x_tb <= "1100"; y_tb <= "0010";
  wait for clock_period;

  x_tb <= "1100"; y_tb <= "0100";
  wait for clock_period;
  sim_end <= true;
  end process stimulus;
end testbench;
