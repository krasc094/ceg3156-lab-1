library ieee;
use ieee.std_logic_1164.all;

entity propogate_mult_nbit is
  generic( n : integer := 9 );
  port (
  x, y : in std_logic_vector(n-1 downto 0);
  product : out std_logic_vector( (2*n)-1 downto 0)
  );
end propogate_mult_nbit;

architecture rtl of propogate_mult_nbit is
component fulladder_1bit is
  port (
  a, b, ci : in std_logic;
  s, co : out std_logic
  );
end component;
signal int_a, msb_carry : std_logic_vector (n-1 downto 0);
signal int_result : std_logic_vector(2 * (n-1) downto 0);
signal sum_propogate : std_logic_vector(1 + (n-1)*(n-2) downto 0);

signal int_xy : std_logic_vector(n-1 downto 0);
signal zero : std_logic;

begin
zero <= '0';

msb_carry(0) <= '0';
int_a <= x and y;
int_xy <= x and y;
sum_propogate(n-2 downto 0) <= int_xy(n-1 downto 1);
product(0) <= int_xy(0);
product((2*n)-1 downto n-1) <= sum_propogate((n-1)*(n-2) downto ((n-1)-1)*(n-2));

row: for i in n-1 downto 1 generate 
-- this generates a row
-- i is the nth row down
  signal int_local_carry : std_logic_vector(n-1 downto 0);
  signal int_b, int_sum: std_logic_vector(n-1 downto 0);

begin

  int_b <= sum_propogate((n-2)*(i) downto (n-2)*(i-1));
  int_result(i) <= int_b(0);

  add_lsb: fulladder_1bit port map (
    -- always the 0th position (rightmost) in the row
    a => int_a(0),
    b => int_b(1),
    s => product(i),
    ci => zero, 
    co => int_local_carry(0)
  );
  add_msb: fulladder_1bit port map (
    -- always the nth position (leftmost) in the row
    a => int_a(n-1),
    b => msb_carry(i-1),
    s => sum_propogate((n-1) + ((i-1) * (n-2))),
    ci => int_local_carry(n-1),
    co => msb_carry(i)
  );

  adders: for j in n-2 downto 1 generate
    -- j is the position relative to the rest of the row
    -- j + i gives the real position of what bit is supposed to be output
    -- each row (num i) offsets the position by 1 to the left

    int_a <= x and y;

    add_i: fulladder_1bit
    port map (
    a => int_a(j),
    b => int_b(j),
    s => sum_propogate(j + ((i-1) * (n-2))),
    ci => int_local_carry(j-1),
    co => int_local_carry(j)
    );
  end generate;
end generate;

end rtl;

library ieee;
use ieee.std_logic_1164.all;
entity multTB is
end multTB;
architecture testbench of multTB is 
  signal x_tb, y_tb : std_logic_vector(8 downto 0) := "000000000";
  signal product_tb : std_logic_vector(17 downto 0) := "000000000000000000";

  signal clock_tb : std_logic := '0';
  signal sim_end : BOOLEAN := false;

  constant CLOCK_PERIOD : time := 20 ns;
component propogate_mult_nbit is
  generic( n : integer := 9 );
  port (
  x, y : in std_logic_vector(n-1 downto 0);
  product : out std_logic_vector( (2*n)-1 downto 0)
  );
end component;
begin
  dut: propogate_mult_nbit 
  port map (
    x => x_tb,
    y => y_tb, 
    product => product_tb
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

  x_tb <= "000000111"; y_tb <= "000000110";
  wait for clock_period;

  wait for clock_period;

  sim_end <= true;
  end process stimulus;
end testbench;
