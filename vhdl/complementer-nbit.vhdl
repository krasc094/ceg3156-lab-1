library ieee;
use ieee.std_logic_1164.all;
entity nBitInverter is 
  generic ( n : integer := 1 );
  port (
    a_i : in std_logic_vector(n-1 downto 0);
    i_invert: in std_logic;
    o : out std_logic_vector(n-1 downto 0)
  );
end nBitInverter;

architecture structural of nBitInverter is
  signal int_a, int_s : std_logic_vector(n-1 downto 0);
  begin

xors: for i in n-1 downto 0 generate
  o(i) <= a_i(i) xor i_invert;
end generate;

end structural;
