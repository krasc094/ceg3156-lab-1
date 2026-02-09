-- ==== 4x1 MUX
library ieee;
use ieee.std_logic_1164.all;
entity mux4_1bit is 
  port (
  a, b, c, d : in std_logic;
  sel : in std_logic_vector(1 downto 0);
  o : out std_logic
);
end mux4_1bit;

architecture structural of mux4_1bit is
-- s1, s0  
-- a for 00
-- b for 01
-- c for 10
-- d for 11
begin
  o <= (a and (not sel(1)) and (not sel(0)) ) or 
       (b and (not sel(1) and sel(0))) or 
       (c and sel(1) and (not sel(0))) or  
       (d and sel(1) and sel(0));
end structural;
