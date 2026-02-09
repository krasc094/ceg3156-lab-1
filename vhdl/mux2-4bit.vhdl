
-- ==== 2x4 MULTIPLEXER 
library ieee;
use ieee.std_logic_1164.all;
entity mux2x1_4bit is 
  port (
    a, b: in std_logic_vector(3 downto 0);
    sel : in std_logic;
    o : out std_logic_vector(3 downto 0)
  );
end entity;

architecture structural of mux2x1_4bit is
begin
  -- sel(1, 0)
  -- a == 0
  -- b == 1 
  o(3) <= (a(3) and not sel) or (b(3) and sel);
  o(2) <= (a(2) and not sel) or (b(2) and sel);
  o(1) <= (a(1) and not sel) or (b(1) and sel);
  o(0) <= (a(0) and not sel) or (b(0) and sel);
end architecture;
