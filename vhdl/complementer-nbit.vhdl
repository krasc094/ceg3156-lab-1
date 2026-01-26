library ieee;
use ieee.std_logic_1164.all;
entity nBitInverter is 
  generic ( n : integer := 1 );
  port (
    a, s: in std_logic_vector(n-1 downto 0);
    o : out std_logic_vector(n-1 downto 0)
  );
end nBitInverter;

architecture structural of nBitInverter is
  component inverter is
  port (
    a, s: in std_logic;
    o : out std_logic
  );
  end component;

  signal int_a, int_s : std_logic_vector(n-1 downto 0);
  signal int_o : std_logic_vector(n-1 downto 0);
  begin

xors: for i in n-1 downto 0 generate
  b_xor: inverter
    port map (
      a => int_a(i),
      s => int_s(i),
      o => int_o(i)
    );
end generate;

  o <= int_o;
end structural;
