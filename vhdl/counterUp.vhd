library ieee;
library altera;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;
use altera.altera_primitives_components.all;

entity counterUp is
    port (
        CLK, RESETN: in std_logic;
        EN, LOAD: in std_logic;
        INPUT: in std_logic_vector(7 downto 0); -- 8 bit value
        EXPIRE: out std_logic;
        OUTPUT: out std_logic_vector(7 downto 0) --  8 bit val, where each bit will be put into MUX
    );
end counterUp;

architecture Structural of counterUp is
    component dFF_2 is
        port (
            i_d		: IN	STD_LOGIC;
				i_clock		: IN	STD_LOGIC;
				o_q, o_qBar	: OUT	STD_LOGIC
        );
    end component;
    
	 signal signalNext: std_logic_vector(7 downto 0);
    signal signalD, signalQ: std_logic_vector(7 downto 0);
	 signal carry : std_logic_vector(8 downto 0);
	 
begin
	 carry(0) <= EN;
	 
	 generateNext: for i in 0 to 7 generate
        signalNext(i) <= signalQ(i) xor carry(i);
        carry(i+1) <= signalQ(i) and carry(i);
    end generate;
	 
	 generateSignalD: for i in 7 downto 0 generate
		signalD(i) <= (signalNext(i) and not(LOAD)) or (INPUT(i) and LOAD);
	 end generate;
	       
    generateDFF: for i in 7 downto 0 generate
        dffInst: dFF_2
            port map (
                i_d => signalD(i),
                i_clock => CLK,
                o_q => signalQ(i),
					 o_qBar => open
            );
    end generate;
    
    EXPIRE <= not or_reduce(signalQ);
    OUTPUT <= signalQ;
end;
