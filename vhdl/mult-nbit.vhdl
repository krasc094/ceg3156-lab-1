-- parametric propogate carry propogate multiplier

library ieee;
use ieee.std_logic_1164.all;

entity mult_nbit is
generic ( n : integer := 9);
port (
  a, b : in std_logic_vector(n-1 downto 0);
  o : out std_logic_vector((2*n)-1 downto 0)
);
end mult_nbit;

architecture rtl of mult_nbit is
  component fulladder_1bit is
    port (
      a, b, ci : in std_logic;
      s, co : out std_logic
    );
  end component;

  signal zero : std_logic;

  signal sum_propagate : std_logic_vector((n-1)*(n)-1 downto 0);
  signal msb_carry : std_logic_vector(n-1 downto 0);
  signal result : std_logic_vector((2*n)-1 downto 0);

  signal int_row0_b : std_logic_vector(n-2 downto 0);
begin
  o <= result;
  result(0) <= a(0) and b(0);
  result((2*n)-2 downto n) <= sum_propagate((n-1)*(n)-1 downto (n-1)*(n)-n+1);
  result((2*n)-1) <= msb_carry(n-1);
  
  intb0: for l in n-2 downto 0 generate begin
    int_row0_b(l) <= b(0);
  end generate;

  msb_carry(0) <= '0'; 
  sum_propagate(n-2 downto 0) <= a(n-1 downto 1) and int_row0_b;

  rows: for i in n-1 downto 1 generate --- i is row
      signal local_carry : std_logic_vector (n-2 downto 0);
      signal int_x : std_logic_vector(n-1 downto 0);
      signal int_row_b : std_logic_vector(n-1 downto 0);
  begin
    --- i really hate this
    intb: for k in n-1 downto 0 generate begin
      int_row_b(k) <= b(i);
    end generate;

    int_x <= a and int_row_b;

    msb: fulladder_1bit
    port map (
      a => int_x(n-1),
      b => msb_carry(i-1),
      ci => local_carry(n-2),
      co => msb_carry(i),
      s => sum_propagate((i+1)*(n-1) - 1)
    ); 

    lsb: fulladder_1bit 
    port map (
      a => int_x(0), 
      b => sum_propagate((i-1)*(n-1)),
      ci => '0',
      co => local_carry(0),
      s => result(i)
    );

    adders: for j in n-2 downto 1 generate --- j is col
    begin
    
      a_i: fulladder_1bit 
      port map (
        a => int_x(j), 
        b => sum_propagate((i-1)*(n-1) + j),
        ci => local_carry(j-1),
        co => local_carry(j),
        s => sum_propagate((i * (n-1)) + j - 1)
      );
    
    end generate;
  end generate;
end architecture;

library ieee;
use ieee.std_logic_1164.all;
entity multTB is 
  end multTB;

architecture testbench of multTB is 
  signal clock_tb : std_logic := '0';
  signal a_tb, b_tb : std_logic_vector(8 downto 0);
  signal o_tb : std_logic_vector(17 downto 0);
  
  component mult_nbit is
    generic ( n : integer := 9);
    port (
      a, b : in std_logic_vector(8 downto 0);
      o : out std_logic_vector(17 downto 0)
    );
  end component;

  signal sim_end : BOOLEAN := false;
  constant CLOCK_PERIOD : time := 20 ns;

begin
  dut: mult_nbit
  port map (
             a => a_tb,
             b => b_tb,
             o => o_tb);

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
  a_tb <= "000000110"; b_tb <= "000000111";
  wait for clock_period;
  assert o_tb = "000000000000101010" report "6x7 failed";
  wait for clock_period;
  -- Edge cases
  a_tb <= "000000000"; b_tb <= "000000000";  -- 0 × 0 = 0
  wait for clock_period;
  assert o_tb = "000000000000000000" report "0x0 failed";

  a_tb <= "000000001"; b_tb <= "000000001";  -- 1 × 1 = 1
  wait for clock_period;
  assert o_tb = "000000000000000001" report "1x1 failed";

  a_tb <= "111111111"; b_tb <= "000000001";  -- 511 × 1 = 511
  wait for clock_period;
  assert o_tb = "000000000111111111" report "511x1 failed";

  a_tb <= "000000001"; b_tb <= "111111111";  -- 1 × 511 = 511
  wait for clock_period;
  assert o_tb = "000000000111111111" report "1x511 failed";

  -- Maximum value
  a_tb <= "111111111"; b_tb <= "111111111";  -- 511 × 511 = 261121 = 0x3FE01
  wait for clock_period;
  assert o_tb = "111111110000000001" report "511x511 failed";

  -- Powers of 2
  a_tb <= "000000010"; b_tb <= "000001000";  -- 2 × 8 = 16
  wait for clock_period;
  assert o_tb = "000000000000010000" report "2x8 failed";

  a_tb <= "000010000"; b_tb <= "000010000";  -- 16 × 16 = 256
  wait for clock_period;
  assert o_tb = "000000000100000000" report "16x16 failed";

  -- Random cases
  a_tb <= "000001010"; b_tb <= "000001111";  -- 10 × 15 = 150
  wait for clock_period;
  assert o_tb = "000000000010010110" report "10x15 failed";

  a_tb <= "001100011"; b_tb <= "000010101";  -- 99 × 21 = 2079
  wait for clock_period;
  assert o_tb = "000000100000011111" report "99x21 failed";

  a_tb <= "000110010"; b_tb <= "001000111";  -- 50 × 71 = 3550
  wait for clock_period;
  assert o_tb = "000000110111011110" report "50x71 failed";
  
  sim_end <= true;

end process stimulus;
end testbench;
