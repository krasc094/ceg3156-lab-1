
-- ==== N-BIT SHIFT REGISTER
library ieee;
use ieee.std_logic_1164.all;

entity shiftRegister is
  generic ( n : integer := 4 );
  port ( 
  clock, reset : in std_logic;
  load, shiftL, shiftR : in std_logic;
  shiftExtension : in std_logic;

  d : in std_logic_vector(n-1 downto 0);
  o : out std_logic_vector(n-1 downto 0)
);
end shiftRegister;

architecture structural of shiftRegister is  
  signal int_d : std_logic_vector(n-1 downto 0);
  signal int_q : std_logic_vector(n-1 downto 0);
  signal int_sel : std_logic_vector(1 downto 0);
  
  component dFlipFlop is 
    port (
      i_d			: in	std_logic;
      i_clk			: in	std_logic;
      i_reset_bar : in std_logic;
      o_q, o_qBar		: out	std_logic
    );
  end component;

  component mux4_1bit is
    port (
      a, b, c, d : in std_logic;
      sel : in std_logic_vector(1 downto 0);
      o : out std_logic
    ); 
  end component;
begin
 
  o <= int_q;  
 
  -- == MUXES have to seperate out LSB and MSB to add optional shift extension
  -- LOAD takes priority over shift
  int_sel(1) <= shiftL or load;
  int_sel(0) <= shiftR or load;

  muxes: for i in n-2 downto 1 generate
  begin
    mux_i : mux4_1bit 
    port map (
      a => int_q(i), -- hold
      b => int_q(i+1), -- shift L
      c => int_q(i-1), -- shift R
      d => d(i), -- load 
      sel => int_sel,
      o => int_d(i)
    );

  end generate;
  
  -- rightmost
  mux_lsb: mux4_1bit
  port map (
    a => int_q(0),
    b => int_q(1),
    c => shiftExtension,
    d => d(0), 
    sel => int_sel,
    o => int_d(0)
  );
  
  -- leftmost
  mux_msb: mux4_1bit
  port map (
    a => int_q(n-1),
    b => shiftExtension,
    c => int_q(n-2),
    d => d(n-1), 
    sel => int_sel,
    o => int_d(n-1)
  );

  bits: for i in n-1 downto 0 generate
  begin
    b_i : dFlipFlop
    port map (
      i_clk => clock,
      i_reset_bar => reset,
      i_d => int_d(i),
      o_q => int_q(i)
    );
  end generate;

end structural;

-- ==== SHIFT REGISTER TEST BENCH
library ieee;
use ieee.std_logic_1164.all;
entity shiftReg_TB is
  generic ( n : integer := 4 );
  end shiftReg_TB;

architecture testbench of shiftReg_TB is 
  signal clock_tb : std_logic := '0';
  signal d_tb, o_tb: std_logic_vector(n-1 downto 0);
  signal load_TB, shiftL_TB, shiftR_TB, shiftExtension_TB: std_logic := '0'; 
  signal sim_end : BOOLEAN := false;
  constant CLOCK_PERIOD : time := 20 ns;

  component shiftRegister is   
    generic ( n : integer := 4 );
    port ( 
    clock, reset : in std_logic;
    load, shiftL, shiftR : in std_logic;
    shiftExtension : in std_logic;

    d : in std_logic_vector(n-1 downto 0);
    o : out std_logic_vector(n-1 downto 0)
  );
  end component;
begin
  dut: shiftRegister
  port map (
    clock => clock_tb,
    load => load_TB,
    shiftL => shiftL_tb,
    shiftR => shiftR_tb,
    shiftExtension => shiftExtension_tb,
    
    d => d_tb,
    o => o_tb,

    reset => '1'
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
    wait for clock_period / 2;
    d_tb <= "0010"; load_TB <= '1';
    wait for clock_period / 2; -- clock rising edge
    load_TB <= '0';
    wait for clock_period / 2; -- falling 
    assert o_tb = "0010" report "load failed";

    shiftL_TB <= '1'; shiftExtension_TB <= '1';
    wait for clock_period / 2; -- rising
    shiftL_TB <= '0'; shiftExtension_TB <= '0';
    wait for clock_period / 2; -- rising
    assert o_tb = "0101" report "shift failed"; 

    wait for clock_period / 2;
    sim_end <= true;
    wait;
  end process stimulus;
end testbench;
