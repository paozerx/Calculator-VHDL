library ieee;
use ieee.std_logic_1164.all;

entity full_sub is 
	port(
		a, b, c_in : in std_logic;
		c_out, sum : out std_logic
	);
end full_sub;

architecture data_flow of full_sub is
begin  
	c_out <= ((a xor (b xor '1')) and c_in) or (a and (b xor '1'));
	sum <= (a xor (b xor '1')) xor c_in;
end data_flow;



library ieee;
use ieee.std_logic_1164.all;

entity sub_gen is
	generic(N : integer := 10); 
	port(
		c_in: in std_logic;  
		a, b : in std_logic_vector(N-1 downto 0); 
		V : out std_logic; 
		c_out : buffer std_logic;
		sum : out std_logic_vector(N-1 downto 0) 
	);
end sub_gen;

architecture data_flow of sub_gen is
	component full_adder
		port(
			a, b, c_in : in std_logic;
			c_out, sum : out std_logic
		);
	end component;

	signal x : std_logic_vector(N downto 0);
	
begin
	x(0) <= c_in;

	adder: for i in 0 to N-1 generate
		L0: if i = 0 generate
			FA_i: entity WORK.full_adder(data_flow)
				port map (c_in => '1', a => a(i), b => b(i), c_out => x(i+1),sum => sum(i));
		end generate;
		
		L1: if i > 0 and i < (N-1) generate
			FA_i: entity WORK.full_adder(data_flow)
				port map (c_in => x(i), a => a(i), b => b(i), c_out => x(i+1), sum => sum(i));
		end generate;
		
		L2: if i = (N-1) generate
			FA_i: entity WORK.full_adder(data_flow)
				port map (c_in => x(i), a => a(i), b => b(i), c_out => c_out, sum => sum(i));
		end generate;
	end generate;
	
	v <= c_out xor x(N-1);
	

end data_flow;









